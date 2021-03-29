require 'open-uri'

class User < ApplicationRecord
  include Routeable
  include DeviseTokenAuth::Concerns::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates :username,
            presence: true,
            uniqueness: {case_sensitive: false},
            format: {with: /\A[\p{N}\p{L}_]{3,}\z/}

  before_save { self.email.downcase! if self.email }
  after_create :create_homepage
  after_create :subscribe_user_to_all_users_list

  acts_as_voter

  has_attached_file :avatar, styles: { thumb: '100x100#', medium: '640x640#', original: '2048x2048>' },
                    :convert_options => { :all => '-quality 75' },
                    default_url: '/images/user/avatar/:style/missing.jpg'

  has_attached_file :cover, styles: { thumb: '100x100#', cover: '1920x350#', original: '3840x2160>' },
                    :convert_options => { :all => '-quality 75' },
                    default_url: '/images/user/cover/:style/missing.jpg'

  validates_attachment :avatar, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }
  validates :avatar, dimensions: { width: 640, height: 640 }

  validates_attachment :cover, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }
  validates :cover, dimensions: { width: 1920, height: 350 }

  has_one :homepage, dependent: :destroy

  has_many :authored_lists, class_name: 'List'
  has_many :activies, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :summaries, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :lists

  def self.current
    Thread.current[:user]
  end
  def self.current=(user)
    Thread.current[:user] = user
  end

  def owned_lists
    lists.where(user_id: id).distinct
  end

  def unread_notifications
    notifications.where(has_read: false)
  end

  # Update record attributes, requires :current_password when password provided
  #
  # This method also rejects the password field if it is blank (allowing
  # users to change relevant information like the e-mail without changing
  # their password). In case the password field is rejected, the confirmation
  # is also rejected as long as it is also blank.
  def update_with_password(params, *options)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
      update_attributes(params, *options)
      return true
    end

    result = if valid_password?(current_password)
      update_attributes(params, *options)
    else
      self.assign_attributes(params, *options)
      self.valid?
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    clean_up_passwords
    result
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      return where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", {value: login.downcase}]).first
    end
    super(conditions)
  end

  def to_param
    username
  end

  def full_name
    return self.username unless self.first_name? or self.last_name?
    "#{first_name} #{last_name}"
  end

  def first_name_or_username
    first_name.blank? ? username : first_name
  end

  def location
    location = []
    if not city.blank? then location.push(city) end
    if not country.blank? then location.push(country) end
    location.join(', ')
  end

  def top_tags
    ActsAsTaggableOn::Tag.joins(:taggings)
      .joins(ActiveRecord::Base.__send__(:sanitize_sql, ['
        LEFT JOIN (
          SELECT tag_id, MAX(created_at) AS last_created_at FROM taggings
          WHERE tagger_id = :user_id
          GROUP BY tag_id
        ) as last_taggings ON last_taggings.tag_id = tags.id
      ', {:user_id => id}]))
      .where("
        taggings.taggable_type = 'List' AND taggings.taggable_id IN (
          SELECT lists.id FROM lists
          WHERE lists.user_id = :user_id
        )
        OR taggings.tagger_id = :user_id
      ", {:user_id => id})
      .group(:id)
      .group(:last_created_at)
      .order('taggings_count DESC')
      .order('last_created_at DESC')
      .limit(10)
  end

  def self.from_omniauth(auth)
    password = Devise.friendly_token[0,20]
    user_created = false
    user = where(email: auth.info.email).first_or_create do |user|
      user.password = password
      user.username = auth.info.name.parameterize.underscore # assuming the user model has a name
      if ! auth.info.image.empty? then user.avatar = open(auth.info.image) end # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
      user_created = true
    end

    return user, password, user_created
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
        user.username = data['name'].parameterize.underscore if user.username.blank?
      end

      if data = session['devise.google_data'] && session['devise.google_data']['info']
       user.email = data['email'] if user.email.blank?
       user.username = data['name'].parameterize.underscore if user.username.blank?
      end
    end
  end

  def avatar_thumb
    avatar.url(:thumb)
  end

  def short_data
    self.as_json(only: [:id, :about, :first_name, :last_name, :username, :about], methods: [:avatar_thumb, :full_name])
      .merge({url: user_lists_path(self.username)})
  end

  private

    def subscribe_user_to_all_users_list
      if Rails.env.production? && !ENV['IS_REVIEW_APP']
        gb = Gibbon::Request.new
        gb.lists(ENV['ALLUSERS_LIST_ID']).members.create(body: {email_address: self.email, status: "subscribed", merge_fields: {USERNAME: self.username}})
      end
    end
end

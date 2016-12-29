class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates :username,
            presence: true,
            uniqueness: {case_sensitive: false},
            format: {with: /\A[\p{N}\p{L}_]{3,}\z/}

  has_one :homepage, dependent: :destroy

  has_many :authored_lists, class_name: 'List'
  has_many :list_memberships, dependent: :destroy
  has_many :lists, through: :list_memberships do
    # Adds owner id to lists when created through join table
    def add_user_id attributes
      if attributes.is_a?(Array)
        attributes.each {|attrs| attrs[:user_id] = @association.owner.id }
      else
        attributes[:user_id] = @association.owner.id
      end
      attributes
    end

    def build(attributes={}, &block)
      super(add_user_id(attributes), &block)
    end

    def create(attributes={}, &block)
      List.create(add_user_id(attributes), &block)
    end
  end

  def membership_for list
    list.list_memberships.find_by(user: self)
  end

  def can_moderate? list
    membership = membership_for list
    membership && membership.can_moderate?
  end

  def can_edit? list
    membership = membership_for list
    membership && membership.can_edit?
  end

  def can_view? list
    membership = membership_for list
    membership && membership.can_view?
  end

  def visible_lists
    List.visible_to(self)
  end

  def owned_lists
    lists.where('list_memberships.role' => :owner).distinct
  end

  before_save { self.email.downcase! if self.email }
  after_create :create_homepage
  after_create :subscribe_user_to_mailing_list

  acts_as_voter

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

  private

  def subscribe_user_to_mailing_list
    gb = Gibbon::Request.new
    gb.lists(ENV["MAILCHIMP_LIST_ID"]).members.create(body: {email_address: self.email, status: "subscribed", merge_fields: {USERNAME: self.username}})
  end

  protected
    def confirmation_required?
      false
    end
end

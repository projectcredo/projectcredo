class List < ApplicationRecord
  # Modules
  acts_as_taggable
  acts_as_votable

  # Attributes
  enum visibility: {private: 10, contributors: 20, public: 30}, _prefix: :visible_to
  enum participants: {private: 10, contributors: 20, public: 30}, _prefix: :accepts, _suffix: :contributions

  # Scopes
  default_scope { joins(:list_memberships).order(cached_votes_up: :desc, updated_at: :desc) }
  scope :publicly_visible, -> { where(visibility: :public).distinct }
  scope :visible_to, ->(user) do
    where(<<~QUERY
        visibility = #{List.visibilities[:public]}
        OR (
          list_memberships.user_id = #{user.id}
          AND (
            list_memberships.role = #{ListMembership.roles[:owner]}
            OR NOT lists.visibility = #{List.visibilities[:private]}
          )
        )
      QUERY
    ).distinct
  end

  # Callbacks
  after_create ->{ list_memberships.find_or_create_by(list: self, user: user) }
  before_create :set_slug

  # Associations
  belongs_to :user
  has_and_belongs_to_many :homepages
  has_many :list_memberships, dependent: :destroy
  has_many :papers, through: :references
  has_many :references, dependent: :destroy
  has_many :members, through: :list_memberships, source: :user do
    def [] role
      where("list_memberships.role = ?", ListMembership.roles.fetch(role))
    end

    def add user, role: nil
      attrs = {list: @association.owner, user: user}
      attrs.merge!(role: role) if role
      ListMembership.create(attrs)
    end
  end
  has_many :comments, as: :commentable

  # Validations
  validates :name,
            presence: true,
            uniqueness: {
              scope: :user,
              case_sensitive: false,
              message: "must be unique for lists you own."
            }
  validates_associated :list_memberships
  validate :validate_tag

  # Methods
  def owner
    members[:owner].first
  end

  def owner= user
    List.transaction do
      if (owner_membership = list_memberships.find_by(role: :owner))
        owner_membership.update_column(:role, :moderator)
      end

      list_memberships.find_or_create_by(user: user).update_column :role, :owner
    end
  end

  def to_slug
    self.name.downcase.gsub("'", '').scan(/[\p{N}\p{L}]{1,}/).join('-')
  end

  def set_slug
    self.slug = self.to_slug
  end

  def set_slug!
    self.update_column :slug, self.to_slug;
  end

  def to_param
    slug
  end

  def validate_tag
    tag_list.to_a.each do |tag|
      errors.add(:tag_list, "cannot contain special characters") unless tag =~ /^[a-zA-Z0-9 ]+$/
    end
  end
end

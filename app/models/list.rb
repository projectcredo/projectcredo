class List < ApplicationRecord
  enum visibility: {public: 10, private: 20, contributors: 30}, _prefix: :visible_to

  acts_as_taggable
  acts_as_votable

  default_scope { order(cached_votes_up: :desc, updated_at: :desc) }

  scope :publicly_visible, -> { where(visibility: :public) }

  after_create ->{ list_memberships.find_or_create_by(list: self, user: user) }
  before_create :set_slug

  belongs_to :user

  has_and_belongs_to_many :homepages

  has_many :list_memberships, dependent: :destroy
  has_many :members, through: :list_memberships, source: :user do
    def [] role
      where("list_memberships.role = ?", ListMembership.roles.fetch(role))
    end

    def add user, role: nil
      attrs = {list: @association.owner, user: user}
      attrs.merge role: role unless role.nil?
      ListMembership.create(attrs)
    end
  end

  has_many :papers, through: :references
  has_many :references, dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: {
                scope: :user,
                case_sensitive: false,
                message: "must be unique for lists you own."
            }

  def owner
    members[:owner].first
  end

  def owner= user
    List.transaction do
      if (owner_membership = list_memberships.find_by(role: :owner))
        owner_membership.update_column(:role, :moderator)
      end

      list_memberships.find_by(user: user).update_column :role, :owner
    end
  end

  def to_slug
    self.name
      .downcase
      .gsub("'", '')
      .gsub(/[^\p{N}\p{L}]/, '-')
      .gsub(/-{2,}/, '-')
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
end

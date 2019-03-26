class List < ApplicationRecord
  # Modules
  acts_as_taggable
  acts_as_votable
  is_impressionable :counter_cache => true

  # Attributes
  enum visibility: {private: 10, contributors: 20, public: 30}, _prefix: :visible_to
  enum access: {private: 10, contributors: 20, public: 30}, _prefix: :accepts, _suffix: :contributions

  has_attached_file :cover, styles: { thumb: '100x100#', cover: '1280x600#', original: '3840x2160>' },
                    :convert_options => { :all => '-quality 75' },
                    default_url: '/images/list/cover/:style/missing.jpg'
  validates_attachment :cover, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }
  validates :cover, dimensions: { width: 1280, height: 720 }

  # Scopes
  scope :ranked, -> {
    joins("LEFT JOIN homepages_lists ON lists.id = homepages_lists.list_id")
    .group(:id)
    .select('lists.*,COUNT( distinct homepages_lists.homepage_id) AS pins')
    .order('lists.cached_votes_up DESC, pins DESC, lists.updated_at DESC')
  }
  scope :by_activity, -> {
      joins(:activities)
      .group('lists.id')
      .select('lists.*, max(activities.updated_at) as receny')
      .order('receny DESC')
    }
  scope :publicly_visible, -> { joins(:list_memberships).where(visibility: :public).distinct }
  scope :visible_to, ->(user) do
    joins(:list_memberships)
    .where(<<~QUERY
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
  accepts_nested_attributes_for :list_memberships
  has_many :papers, through: :references
  has_many :references, dependent: :destroy
  has_many :summaries, dependent: :destroy
  has_many :posts, dependent: :destroy
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
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :activities, as: :actable, dependent: :destroy

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

  def others
    members[:contributor] +  members[:moderator]
  end

  def total_bookmarks
    self.papers.sum(:bookmarks_count)
  end

  def validate_tag
    tag_list.each do |tag|
      errors.add(:tag_list, "cannot contain special characters") unless tag =~ /\A[\p{N}\p{L} ]+\z/
    end
  end

  def refresh_papers_info
    now = Time.current

    self.papers.each do |paper|
      next unless paper.doi.present? # Skip papers without DOI
      # Skip papers, refreshed lately
      if paper.referenced_by_count_updated_at.present? then
        next unless ((now - paper.referenced_by_count_updated_at) / 60).to_i > Rails.configuration.x.reload_papers_info_timeout
      end

      response = Crossref.get_by_doi paper.doi
      paper.update(response.paper_attributes.slice(:referenced_by_count, :referenced_by_count_updated_at))
    end
  end
end

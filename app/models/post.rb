class Post < ApplicationRecord

  belongs_to :user
  belongs_to :list
  has_and_belongs_to_many :papers
  has_and_belongs_to_many :articles, -> { where('parent_id is null') },  association_foreign_key: 'paper_id', join_table: 'papers_posts'
  validates :user, :presence => true
  validates :list, :presence => true
  validates :content, presence: true

  include HasBookmarks

  def user_short
    user.short_data
  end

end

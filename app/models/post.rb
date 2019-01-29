class Post < ApplicationRecord

  belongs_to :user
  belongs_to :list
  has_and_belongs_to_many :papers
  has_and_belongs_to_many :articles, association_foreign_key: 'paper_id', join_table: 'papers_posts'#, -> { where('parent_id is null') }

  validates :user, :presence => true
  validates :list, :presence => true
  validates :content, presence: true

  include HasBookmarks

end

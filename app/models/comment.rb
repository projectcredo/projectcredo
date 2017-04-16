class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_closure_tree order: 'sort_order'
  acts_as_votable

  validates :content, presence: true

  def self_and_sibling_ids
    self.sibling_ids + [self.id]
  end

  def order_siblings
    Comment
      .where(id: self_and_sibling_ids)
      .order(cached_votes_up: :desc, created_at: :asc)
      .each_with_index {|comment,i| comment.update_column :sort_order, i}
  end
end

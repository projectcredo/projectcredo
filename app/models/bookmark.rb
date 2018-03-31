class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :bookmarkable, polymorphic: true

  after_create    :increment_bookmark_counters
  before_destroy  :decrement_bookmark_counters

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  def self.find_bookmarks_by_user(user)
    find(:all,
         :conditions => ['user_id = ?', user.id],
         :order => 'created_at DESC'
    )
  end

  private
    def increment_bookmark_counters
      bookmarkable.class.increment_counter(:bookmarks_count, bookmarkable.id) if bookmarkable.respond_to?(:bookmarks_count)
    end

    def decrement_bookmark_counters
      bookmarkable.class.decrement_counter(:bookmarks_count, bookmarkable.id) if bookmarkable.respond_to?(:bookmarks_count)
    end
end
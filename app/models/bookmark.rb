class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :bookmarkable, polymorphic: true

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  def self.find_bookmarks_by_user(user)
    find(:all,
         :conditions => ["user_id = ?", user.id],
         :order => "created_at DESC"
    )
  end
end
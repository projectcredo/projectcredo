class AddBookmarksCountToReferences < ActiveRecord::Migration[5.0]
  def change
    add_column :references, :bookmarks_count, :integer, :default => 0
  end
end

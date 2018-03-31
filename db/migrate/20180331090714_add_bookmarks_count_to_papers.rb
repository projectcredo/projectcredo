class AddBookmarksCountToPapers < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :bookmarks_count, :integer, :default => 0
  end
end

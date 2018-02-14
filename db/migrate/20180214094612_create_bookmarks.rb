class CreateBookmarks < ActiveRecord::Migration[5.0]
  def change
    create_table :bookmarks do |t|
      t.integer :user_id, null: false
      t.integer :bookmarkable_id
      t.string :bookmarkable_type
      t.timestamps
    end

    add_index :bookmarks, :user_id
    add_index :bookmarks, [:bookmarkable_id, :bookmarkable_type]
  end
end

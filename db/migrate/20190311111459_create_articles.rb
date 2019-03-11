class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.integer :post_id, null: false
      t.string :title
      t.string :source
      t.string :url
      t.date :published_at
      t.integer :bookmarks_count, :default => 0
      t.attachment :cover
      t.timestamps
    end
    add_foreign_key :articles, :posts
  end
end

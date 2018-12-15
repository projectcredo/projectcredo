class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :list_id
      t.text :content
      t.timestamps
    end

    add_foreign_key :posts, :users
    add_foreign_key :posts, :lists
  end
end

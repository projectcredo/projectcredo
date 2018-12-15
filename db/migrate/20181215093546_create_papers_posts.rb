class CreatePapersPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :papers_posts, id: false do |t|
      t.integer :paper_id
      t.integer :post_id
    end

    add_index :papers_posts, [:paper_id, :post_id], unique: true
    add_foreign_key :papers_posts, :papers
    add_foreign_key :papers_posts, :posts
  end
end

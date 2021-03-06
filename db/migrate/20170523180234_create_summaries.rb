class CreateSummaries < ActiveRecord::Migration[5.0]
  def change
    create_table :summaries do |t|
      t.integer :user_id, null: false
      t.integer :list_id, null: false
      t.text :content, null: false
      t.integer :evidence_rating, null: false
      t.integer :comments, :cached_votes_up, default: 0

      t.timestamps
    end

    add_index :summaries, [:list_id, :user_id, :evidence_rating]
    add_index :summaries, :cached_votes_up
  end
end

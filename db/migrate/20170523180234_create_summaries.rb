class CreateSummaries < ActiveRecord::Migration[5.0]
  def change
    create_table :summaries do |t|
      t.integer :user_id, null: false
      t.integer :list_id, null: false
      t.text :content, null: false
      t.integer :evidence_rating, null: false

      t.timestamps
    end

    add_index :summaries, [:list_id, :user_id, :evidence_rating]
  end
end

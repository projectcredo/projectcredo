class CreateHighlights < ActiveRecord::Migration[5.0]
  def change
    create_table :highlights do |t|
      t.text :substring
      t.references :user, foreign_key: true
      t.references :paper, foreign_key: true

      t.timestamps
    end
  end
end

class AddTypeAndParentIdToPapers < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :type, :string, default: 'paper', null: false
    add_column :papers, :parent_id, :integer, null: true
    add_foreign_key :papers, :papers, column: :parent_id
  end
end

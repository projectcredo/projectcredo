class AddReferencedByCountToPapers < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :referenced_by_count, :integer
    add_column :papers, :referenced_by_count_updated_at, :datetime
  end
end

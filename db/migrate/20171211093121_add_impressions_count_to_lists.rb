class AddImpressionsCountToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :impressions_count, :int, :default => 0
  end
end

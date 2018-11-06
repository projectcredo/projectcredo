class AddCoverColumnsToLists < ActiveRecord::Migration[5.0]
  def self.up
    change_table :lists do |t|
      t.attachment :cover
    end
  end

  def self.down
    remove_attachment :lists, :cover
  end
end

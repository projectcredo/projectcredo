class AddListIdToComments < ActiveRecord::Migration[5.0]
  def change
    change_table :comments do |t|
      t.references :list, :null => true
    end
  end
end

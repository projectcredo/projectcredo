class AddProfileFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :about, :string
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :website, :string
  end
end

class AddOmniauthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :facebook_uid, :string
    add_column :users, :google_uid, :string
  end
end

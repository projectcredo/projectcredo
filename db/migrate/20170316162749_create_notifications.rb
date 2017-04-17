class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :activity_id, index:true
      t.boolean :has_read

      t.timestamps
    end
  end
end

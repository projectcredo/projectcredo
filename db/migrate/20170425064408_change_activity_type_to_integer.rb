class ChangeActivityTypeToInteger < ActiveRecord::Migration[5.0]
  def change
    Activity.delete_all
    change_column :activities, :activity_type, 'integer USING activity_type::integer', null: false
    change_column :activities, :user_id, :integer, null: false
    change_column :activities, :actable_id, :integer, null: false
    change_column :activities, :actable_type, :string, null: false
  end
end

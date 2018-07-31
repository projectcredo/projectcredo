class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.references :plan
      t.string :stripe_id
      t.timestamps
    end
  end
end

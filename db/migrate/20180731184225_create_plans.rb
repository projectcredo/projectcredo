class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :stripe_id
      t.string :name
      t.string :interval
      t.decimal :price
      t.string :currency
      t.timestamps
    end
  end
end

class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :customer_name, null: false
      t.string :address, null: false
      t.integer :orders_count, default: 0, null: false

      t.timestamps
    end
  end
end
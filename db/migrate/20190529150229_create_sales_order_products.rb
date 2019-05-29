class CreateSalesOrderProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :sales_order_products do |t|
    	t.string :product_name
      t.integer :product_id, precision: 38
      t.integer :order_quantity, precision: 38
      t.decimal :order_rate, precision: 38, scale: 4, default: "0.0000"
      t.decimal :order_value, precision: 38, scale: 4, default: "0.0000"
      t.datetime :delivered_date
      t.integer :delivery_quantity, precision: 38
      t.decimal :delivery_rate, precision: 38, scale: 4, default: "0.0000"
      t.decimal :delivery_value, precision: 38, scale: 4, default: "0.0000"

      t.timestamps
    end
  end
end

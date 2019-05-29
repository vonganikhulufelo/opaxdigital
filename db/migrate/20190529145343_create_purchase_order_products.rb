class CreatePurchaseOrderProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_order_products do |t|
    	t.integer :product_id, precision: 38
      t.datetime :delivered_date
      t.string :product_name
      t.decimal :zone_price, precision: 38, scale: 4, default: "0.0000"
      t.integer :order_quantity, precision: 38
      t.decimal :order_value, precision: 38, scale: 4, default: "0.0000"
      t.decimal :purchase_price, precision: 38, scale: 4, default: "0.0000"
      t.decimal :pick_up_value, precision: 38, scale: 4, default: "0.0000"
      t.references :purchase_order, foreign_key: true
      t.integer :pick_up_quantity, precision: 38

      t.timestamps
    end
  end
end
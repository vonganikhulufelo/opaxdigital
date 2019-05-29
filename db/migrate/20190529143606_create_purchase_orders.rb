class CreatePurchaseOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_orders do |t|
    	t.datetime :order_date
      t.string :system__internal_reference
      t.string :internal_po_reference
      t.string :vendor_name
      t.string :vendor_payment
      t.string :product_pescription_product
      t.decimal :product_price_price, precision: 38, scale: 4, default: "0.0000"
      t.decimal :net_price, precision: 38, scale: 4, default: "0.0000"
      t.string :order_qty, precision: 38
      t.decimal :order_value, precision: 38, scale: 4, default: "0.0000"
      t.string :vendor_reference
      t.string :vendor_documentation
      t.datetime :pick_up_date_time
      t.integer :pick_up_qt, precision: 38
      t.decimal :pick_up_value, precision: 38, scale: 4, default: "0.0000"
      t.decimal :total_order_value, precision: 38, scale: 4, default: "0.0000"
      t.decimal :total_delivered_value, precision: 38, scale: 4, default: "0.0000"
      t.string :bol_reference
      t.string :status
      t.string :uid
      t.string :recon_status
      t.string :zone
      t.integer :zone_id, precision: 38
      t.integer :vendor_id, precision: 38
      t.integer :payment_id, precision: 38
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

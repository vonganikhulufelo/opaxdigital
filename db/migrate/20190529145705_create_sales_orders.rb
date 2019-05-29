class CreateSalesOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :sales_orders do |t|
    	t.datetime :delivered_date
      t.string :customer_name
      t.integer :customer_id, precision: 38
      t.string :zone
      t.integer :zone_id, precision: 38
      t.string :payment
      t.integer :payment_id, precision: 38
      t.boolean :invoice,default: "false"
      t.string :puma_reference
      t.string :delivery_note_reference
      t.string :delivery_attachment
      t.string :status
      t.string :recon
      t.string :uid
      t.datetime :delivery_date_on_delivery
      t.decimal :total_delivery_value, precision: 38, scale: 4, default: "0.0000"
      t.decimal :total_order_value, precision: 38, scale: 4, default: "0.0000"
      t.datetime :order_date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
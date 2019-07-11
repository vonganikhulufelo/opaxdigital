class CreateTanks < ActiveRecord::Migration[5.2]
  def change
    create_table :tanks do |t|
      t.integer :tank_number, precision: 38
      t.decimal :stock_in, precision: 38, scale: 4, default: "0.0000"
      t.decimal :stock_out, precision: 38, scale: 4, default: "0.0000"
      t.decimal :current_stock, precision: 38, scale: 4, default: "0.0000"
      t.integer :product_description, precision: 38
      t.decimal :tank_size, precision: 38, scale: 4, default: "0.0000"
      t.string :uid

      t.timestamps
    end
  end
end

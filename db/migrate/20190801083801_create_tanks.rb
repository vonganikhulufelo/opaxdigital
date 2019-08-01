class CreateTanks < ActiveRecord::Migration[5.2]
  def change
    create_table :tanks do |t|
      t.string :tank_number
      t.decimal :stock_in, precision: 38, scale: 4, default: "0.0000"
      t.decimal :stock_out, precision: 38, scale: 4, default: "0.0000"
      t.decimal :current_stock, precision: 38, scale: 4, default: "0.0000"
      t.decimal :tank_volume, precision: 38, scale: 4, default: "0.0000"
      t.decimal :opening_stock, precision: 38, scale: 4, default: "0.0000"
      t.decimal :closing_stock, precision: 38, scale: 4, default: "0.0000"
      t.string :uid
      t.references :product_description, foreign_key: true
      t.references :user, foreign_key: true
      t.references :site, foreign_key: true

      t.timestamps
    end
  end
end

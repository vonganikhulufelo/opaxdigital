class CreateProductPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :product_prices do |t|
      t.datetime :productprice_month_id
      t.string :productprice_zone_class
      t.decimal :productprice_price, precision: 38, scale: 4, default: "0.0000"
      t.string :productdescription_product
      t.string :uid
      t.references :product_description, foreign_key: true
      t.references :user, foreign_key: true
      t.references :zone, foreign_key: true

      t.timestamps
    end
  end
end

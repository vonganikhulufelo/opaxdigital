class CreateSPayMProductPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :s_pay_m_product_prices do |t|
    	t.string :product_price_price
      t.string :product_pescription_product
      t.decimal :product_rebate, precision: 38, scale: 4, default: "0.0000"
      t.decimal :net_price, precision: 38, scale: 4, default: "0.0000"
      t.decimal :claw_margin, precision: 38, scale: 4, default: "0.0000"
      t.string :uid
      t.references :product_description, foreign_key: true
      t.references :product_price, foreign_key: true
      t.references :s_pay_m_district, foreign_key: true
      t.timestamps
    end
  end
end

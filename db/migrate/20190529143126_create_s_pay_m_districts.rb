class CreateSPayMDistricts < ActiveRecord::Migration[5.2]
  def change
    create_table :s_pay_m_districts do |t|
    	t.string :magisterialdistrict_zone
      t.string :magisterialdistrict_district
      t.string :magisterialdistrict_code
      t.references :magisterial_district, foreign_key: true
      t.references :supplier_payment_term, foreign_key: true
      t.timestamps
    end
  end
end

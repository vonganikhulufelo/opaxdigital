class CreateMagisterialDistricts < ActiveRecord::Migration[5.2]
  def change
    create_table :magisterial_districts do |t|
    	t.string :magisterialdistrict_zone
      t.string :magisterialdistrict_district
      t.string :magisterialdistrict_code
      t.string :magisterialdistrict_province
      t.string :uid
      t.references :user, foreign_key: true
      t.references :zone, foreign_key: true

      t.timestamps
    end
  end
end

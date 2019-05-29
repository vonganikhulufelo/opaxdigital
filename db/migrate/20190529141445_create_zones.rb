class CreateZones < ActiveRecord::Migration[5.2]
  def change
    create_table :zones do |t|
    	t.string :zone_description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

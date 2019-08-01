class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.string :site_number
      t.string :site_location
      t.string :uid
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

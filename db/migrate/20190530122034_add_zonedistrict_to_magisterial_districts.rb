class AddZonedistrictToMagisterialDistricts < ActiveRecord::Migration[5.2]
  def change
    add_column :magisterial_districts, :zonedistrict, :string
  end
end

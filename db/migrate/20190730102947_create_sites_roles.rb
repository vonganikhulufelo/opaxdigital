class CreateSitesRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :sites_roles do |t|
      t.references :user, foreign_key: true
      t.references :site, foreign_key: true

      t.timestamps
    end
  end
end

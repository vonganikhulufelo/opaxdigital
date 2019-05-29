class CreateSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :suppliers do |t|
      t.string :supplier_name
      t.string :supplier_address
      t.string :supplier_contact
      t.string :supplier_email
      t.string :uid
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

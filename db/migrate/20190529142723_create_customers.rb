class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :customer_name
      t.string :location
      t.string :customer_address
      t.string :customer_contact
      t.string :customer_email
      t.string :uid
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

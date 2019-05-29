class CreateProductDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :product_descriptions do |t|
    	t.string :productdescription_product
      t.string :uid
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

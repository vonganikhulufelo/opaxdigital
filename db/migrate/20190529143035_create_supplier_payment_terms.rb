class CreateSupplierPaymentTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :supplier_payment_terms do |t|
    	t.string :payment_term_description
      t.string :payment_term_threshold
      t.references :supplier, foreign_key: true
      t.references :payment_term, foreign_key: true
      t.timestamps
    end
  end
end

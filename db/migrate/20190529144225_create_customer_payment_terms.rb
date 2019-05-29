class CreateCustomerPaymentTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :customer_payment_terms do |t|
    	t.string :payment_term_description
      t.integer :payment_term_threshold
      t.references :payment_term, foreign_key: true
      t.references :customer, foreign_key: true

      t.timestamps
    end
  end
end

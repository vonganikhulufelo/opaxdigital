class CreatePaymentTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_terms do |t|
    	t.string :paymentterm_description
      t.string :paymentterm_threshold
      t.string :uid
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

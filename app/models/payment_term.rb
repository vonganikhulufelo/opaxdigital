class PaymentTerm < ApplicationRecord
  belongs_to :user
  has_many :supplier_payment_terms, dependent: :destroy
  has_many :customer_payment_terms, dependent: :destroy
end

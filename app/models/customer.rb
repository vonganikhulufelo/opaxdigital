class Customer < ApplicationRecord
  belongs_to :user
  has_many :customer_payment_terms, dependent: :destroy
end

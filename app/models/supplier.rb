class Supplier < ApplicationRecord
  belongs_to :user
  has_many :supplier_payment_terms, dependent: :destroy
  has_many :c_pay_m_product_prices, dependent: :destroy
end

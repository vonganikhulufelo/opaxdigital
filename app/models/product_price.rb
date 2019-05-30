class ProductPrice < ApplicationRecord
  belongs_to :product_description
  belongs_to :user
  belongs_to :zone
  has_many :s_pay_m_product_prices, dependent: :destroy
  has_many :c_pay_m_product_prices, dependent: :destroy
end

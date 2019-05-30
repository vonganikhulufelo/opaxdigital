class ProductDescription < ApplicationRecord
  belongs_to :user
  has_many :product_prices, dependent: :destroy
  has_many :c_pay_m_product_prices, dependent: :destroy

end

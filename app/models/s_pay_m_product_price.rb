class SPayMProductPrice < ApplicationRecord
  belongs_to :product_description
  belongs_to :product_price
  belongs_to :s_pay_m_district
  has_many :c_pay_m_product_prices, dependent: :destroy
 
end

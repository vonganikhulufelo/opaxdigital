class CPayMDistrict < ApplicationRecord
  belongs_to :magisterial_district
  belongs_to :customer_payment_term
  has_many :c_pay_m_product_prices, dependent: :destroy
end

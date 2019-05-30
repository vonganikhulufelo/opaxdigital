class SPayMDistrict < ApplicationRecord
  belongs_to :magisterial_district
  belongs_to :supplier_payment_term
  has_many :s_pay_m_product_prices, dependent: :destroy
end

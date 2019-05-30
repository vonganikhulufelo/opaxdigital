class CPayMProductPrice < ApplicationRecord
  belongs_to :product_description
  belongs_to :product_price
  belongs_to :c_pay_m_district
  belongs_to :supplier
  belongs_to :s_pay_m_product_price
end

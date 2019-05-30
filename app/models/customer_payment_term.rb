class CustomerPaymentTerm < ApplicationRecord
  belongs_to :payment_term
  belongs_to :customer
  has_many :c_pay_m_districts, dependent: :destroy
end

class SupplierPaymentTerm < ApplicationRecord
  belongs_to :supplier
  belongs_to :payment_term
  has_many :s_pay_m_districts, dependent: :destroy
end

class PaymentTerm < ApplicationRecord
  belongs_to :user
  has_many :supplier_payment_terms, dependent: :destroy
  has_many :customer_payment_terms, dependent: :destroy

  after_destroy :create_logs

  def create_logs
  	@log = Log.where(uid: self.uid).last
  	Log.where(uid: self.uid).destroy_all
    Log.create!(user_id: self.user_id, uid: 'Delete', description: @log.description)
  end
end

class ProductPrice < ApplicationRecord
  belongs_to :product_description
  belongs_to :user
  belongs_to :zone
  has_many :s_pay_m_product_prices, dependent: :destroy
  has_many :c_pay_m_product_prices, dependent: :destroy
  after_destroy :create_logs

  def create_logs
  	@log = Log.where(uid: self.uid).last
  	Log.where(uid: self.uid).destroy_all
    Log.create!(user_id: self.user_id, uid: 'Delete', description: @log.description)
  end

  def self.search(search)
    if search
      where('productprice_zone_class LIKE ?', "%#{search}%")
    else
      all
    end
  end
end

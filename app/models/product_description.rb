class ProductDescription < ApplicationRecord
  belongs_to :user
  has_many :product_prices, dependent: :destroy
  has_many :c_pay_m_product_prices, dependent: :destroy
  has_many :tanks, dependent: :destroy
  after_destroy :create_logs

  def create_logs
  	@log = Log.where(uid: self.uid).last
  	Log.where(uid: self.uid).destroy_all
    Log.create!(user_id: self.user_id, uid: 'Delete', description: @log.description)
  end

  def self.search(search)
    if search
      where('LOWER(productdescription_product) LIKE ?', "%#{search.downcase}%")
    else
      all
    end
  end
end

class PurchaseOrderProduct < ApplicationRecord
  belongs_to :purchase_order, optional: true
  validates :zone_price, presence: true
  before_save :product

  def product
  	@p = ProductDescription.find_by(productdescription_product: self.product_name)
  	self.product_id = @p.id
  end 
end

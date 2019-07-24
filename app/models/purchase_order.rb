class PurchaseOrder < ApplicationRecord
  belongs_to :user
  has_many :purchase_order_products, dependent: :destroy
  accepts_nested_attributes_for :purchase_order_products,  reject_if: :all_blank, allow_destroy: true
  mount_uploader :vendor_documentation, VendorDocumentationUploader
  before_save :total_order_value
  
  def total_order_value
    PurchaseOrder.where(id: @purchase.to_a).sum(:order_value)
  end

  def self.search(search)
  	if search
    	where('LOWER(vendor_name) LIKE ?', "%#{search.downcase}%")
  	else
    	all
  	end
  end
end

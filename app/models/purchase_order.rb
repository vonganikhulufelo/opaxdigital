class PurchaseOrder < ApplicationRecord
  belongs_to :user
  has_many :purchase_order_products, dependent: :destroy
  accepts_nested_attributes_for :purchase_order_products,  reject_if: :all_blank, allow_destroy: true
  mount_uploader :vendor_documentation, VendorDocumentationUploader

  def self.search(search)
  	if search
    	where('vendor_name LIKE ?', "%#{search}%")
  	else
    	all
  	end
  end
end

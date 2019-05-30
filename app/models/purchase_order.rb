class PurchaseOrder < ApplicationRecord
	  belongs_to :user
  has_many :purchase_order_products, dependent: :destroy
  accepts_nested_attributes_for :purchase_order_products,  reject_if: :all_blank, allow_destroy: true
end

class SalesOrder < ApplicationRecord
  belongs_to :user
  has_many :sales_order_products, :dependent => :destroy
  accepts_nested_attributes_for :sales_order_products, reject_if: :all_blank, allow_destroy: true
end

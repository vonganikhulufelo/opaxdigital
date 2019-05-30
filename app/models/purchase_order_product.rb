class PurchaseOrderProduct < ApplicationRecord
  belongs_to :purchase_order, optional: true
  validates :zone_price, presence: true
end

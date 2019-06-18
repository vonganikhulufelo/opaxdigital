class SalesOrder < ApplicationRecord
  belongs_to :user
  has_many :sales_order_products, :dependent => :destroy
  accepts_nested_attributes_for :sales_order_products, reject_if: :all_blank, allow_destroy: true

  def self.search(search)
  	if search
    	where('LOWER(customer_name) LIKE ?', "%#{search.downcase}%")
  	else
    	all
  	end
  end
end

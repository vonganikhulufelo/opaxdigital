class SalesOrderProduct < ApplicationRecord
  belongs_to :sales_order, optional: true
end

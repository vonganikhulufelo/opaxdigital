class Tank < ApplicationRecord
  belongs_to :product_description
  belongs_to :user
  belongs_to :site
end

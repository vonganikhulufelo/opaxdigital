class Zone < ApplicationRecord
  belongs_to :user
  has_many :product_prices, dependent: :destroy
  has_many :magisterial_districts, dependent: :destroy
end

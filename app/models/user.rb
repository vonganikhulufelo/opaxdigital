class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  has_many :suppliers, dependent: :destroy
  has_many :payment_terms, dependent: :destroy
  has_many :logs, dependent: :destroy
  has_many :zones, dependent: :destroy
  has_many :magisterial_districts, dependent: :destroy
  has_many :product_prices, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :sales_orders, dependent: :destroy
end

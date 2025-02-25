class User < ApplicationRecord
  rolify
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
  has_many :product_descriptions, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :sales_orders, dependent: :destroy
  has_many :tanks, dependent: :destroy
  has_many :sites_roles, dependent: :destroy
  has_many :sites, dependent: :destroy
  after_destroy :create_logs

  def create_logs
    @log = Log.where(uid: self.uid).last
    Log.where(uid: self.uid).destroy_all
    #Log.create!(user_id: self.user_id, uid: 'Delete', description: @log.description)
  end
end

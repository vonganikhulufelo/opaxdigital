class MagisterialDistrict < ApplicationRecord
  belongs_to :user
  belongs_to :zone
  has_many :s_pay_m_districts, dependent: :destroy
  has_many :c_pay_m_districts, dependent: :destroy
  before_save :zonedistrict

  def zonedistrict
    self.zonedistrict = "#{self.magisterialdistrict_zone}" + " " + "#{self.magisterialdistrict_district.to_s}"
  end
end

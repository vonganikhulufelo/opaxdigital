class SitesRole < ApplicationRecord
  belongs_to :user
  belongs_to :site
  validates :user_id, uniqueness: true
end

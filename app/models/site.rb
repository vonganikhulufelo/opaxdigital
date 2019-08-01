class Site < ApplicationRecord
  belongs_to :user
  has_many :tanks, dependent: :destroy
  has_many :sites_roles, dependent: :destroy
  def self.search(search)
  	if search
    	where('LOWER(site_number) LIKE ?', "%#{search.downcase}%")
  	else
    	all
  	end
  end
end

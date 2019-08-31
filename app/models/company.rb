class Company < ApplicationRecord
	belongs_to :seller
	belongs_to :address
end

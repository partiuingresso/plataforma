class SellerStaff < ApplicationRecord
	self.table_name = 'seller_staff'
    has_one :user, as: :actor
	belongs_to :seller
end

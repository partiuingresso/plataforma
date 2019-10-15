class RemoveSellerStaff < ApplicationService
	attr_reader :assign_user_data, :seller

	def initialize(seller, assign_user_data)
		@seller = seller
		@assign_user_data ||= assign_user_data
	end

	def call
		begin
			ActiveRecord::Base.transaction do
				@assign_user = User.find(assign_user_data[:user_id])
				unless @assign_user.producer? && seller.staff_users.include?(@assign_user)
					raise ActiveRecord::Rollback
				end

				@assign_user.seller_staff.destroy!
				@assign_user.role = :user
				@assign_user.actor = nil
				@assign_user.save!

				@success = true
			end
		rescue => e
			@success = false
			raise
		end

		return self
	end
end

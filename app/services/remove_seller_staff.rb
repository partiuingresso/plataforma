class RemoveSellerStaff < ApplicationService
	attr_reader :user, :assign_user_data, :seller

	def initialize(user, assign_user_data)
		@user = user
		@assign_user_data ||= assign_user_data
	end

	def call
		begin
			ActiveRecord::Base.transaction do
				load_seller
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

	private

		def load_seller
			@seller = user.seller
		end
end

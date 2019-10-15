class CreateSellerStaff < ApplicationService
	attr_reader :user, :assign_user_data, :seller

	def initialize(seller, assign_user_data)
		super()
		@seller = seller
		@assign_user_data = assign_user_data
	end

	def call
		begin
			ActiveRecord::Base.transaction do
				@assign_user = User.find_by_email(assign_user_data[:email])
				unless @assign_user.present?
					set_error_message "Usuário não encontrado."
					raise ActiveRecord::Rollback
				end

				unless @assign_user.user? && seller.staff_users.exclude?(@assign_user)
					raise ActiveRecord::Rollback
				end

				@assign_user.build_seller_staff(seller: seller)
				@assign_user.role = :producer

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
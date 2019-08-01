class Admin::DashboardController < ApplicationController
	authorize_resource :class => false

	def show
	    @companies = Company.all
	    @orders = Order.where(created_at: 28.day.ago..DateTime.now)
	    @tickets = OrderItem.where(order_id: @orders.approved).sum('quantity')
	end

	private

		def current_ability
			@current_ability ||= AdminAbility.new(current_user)
		end
end

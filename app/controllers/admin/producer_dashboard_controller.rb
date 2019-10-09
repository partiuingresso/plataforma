class Admin::ProducerDashboardController < ApplicationController
	authorize_resource :class => false
	
	def show
		@seller = Seller.find(params[:seller_id])
	    balances = Wirecard::show_balances @seller
	    if balances.respond_to?(:future) && balances.future.present?
	      @total_balance = Money.new(balances.current.first.amount).format
	    else
	      @total_balance = "Not Responding."
	    end
	    
	    @events = @seller.events.order(created_at: :desc).to_happen
	end

	private

		def current_ability
			@current_ability ||= AdminAbility.new(current_user)
		end
end

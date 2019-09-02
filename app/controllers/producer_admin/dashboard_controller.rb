class ProducerAdmin::DashboardController < ApplicationController
	authorize_resource :class => false

	def show
	    balances = Wirecard::show_balances current_user.seller
	    if balances.respond_to?(:future) && balances.future.present?
	      @total_balance = Money.new(balances.current.first.amount).format
	    else
	      @total_balance = "Not Responding."
	    end
	    
	    @events = Event.where(seller_id: current_user.seller_id).order(created_at: :desc).to_happen
	end

	private

		def current_ability
			@current_ability ||= ProducerAdmin::DashboardAbility.new(current_user)
		end
end

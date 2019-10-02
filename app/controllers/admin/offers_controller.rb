class Admin::OffersController < ApplicationController
	load_resource :event
	authorize_resource :offer, through: :event

	def index
		@offers = @event.offers.order(created_at: :desc)
	end

	private

		def current_ability
			@current_ability ||= AdminAbility.new(current_user)
		end

end

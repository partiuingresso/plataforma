class Producer::EventsController < ApplicationController
	load_and_authorize_resource

	def index
		@seller = current_user.seller_staff.seller
	end

	private

		def current_ability
			@current_ability ||= Producer::EventAbility.new(current_user)
		end
end

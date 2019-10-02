class Admin::MarketingsController < ApplicationController
	authorize_resource :class => false
	
	def index
		@event = Event.find(params[:event_id])
		@fb_pixel = @event.fb_pixel
		@ga_id = @event.ga_id
	end

	private
	
		def current_ability
			@current_ability ||= AdminAbility.new(current_user)
		end
end

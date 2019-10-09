class Admin::MarketingsController < ApplicationController
	authorize_resource :class => false
	
	def index
		@event = Event.find(params[:event_id])
		@fb_pixel = @event.fb_pixel
		@ga_id = @event.ga_id
	end

	def update
		event = Event.find(params[:event_id])
		if event.update(marketing_params)
			head :no_content
		else
			head :bad_request
		end
	end

	private
	
		def marketing_params
			params.require(:event).permit(:fb_pixel, :ga_id)
		end

		def current_ability
			@current_ability ||= AdminAbility.new(current_user)
		end
end

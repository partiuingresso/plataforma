class ProducerAdmin::MarketingsController < ApplicationController
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

	def destroy
		event = Event.find(params[:event_id])
		event.update!(fb_pixel: "")
	end

	private

		def marketing_params
			params.require(:event).permit(:fb_pixel, :ga_id)
		end
end

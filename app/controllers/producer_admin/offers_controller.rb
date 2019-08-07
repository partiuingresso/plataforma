class ProducerAdmin::OffersController < ApplicationController
	def index
		@event = Event.find(params[:event_id])
		@offers = @event.offers.order(created_at: :desc)
	end

	def destroy
		@offer = Offer.find(params[:id])
		unless @offer.sold > 0
			@offer.destroy
			head :no_content
		else
			head :bad_request
		end
	end
end

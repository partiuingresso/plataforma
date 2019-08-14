class ProducerAdmin::OffersController < ApplicationController
	def index
		@event = Event.find(params[:event_id])
		@offers = @event.offers.order(created_at: :desc)
	end

	def create
		@event = Event.find(params[:event_id])
		@offer = @event.offers.build(offer_params)
		if @offer.save 
			render json: OfferSerializer.new(@offer).serialized_json 
		else
			head :bad_request
		end
	end

	def update
		@offer = Offer.find(params[:id])
		if @offer.update(offer_params)
			head :no_content
		else
			head :bad_request
		end
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

	private

		def offer_params
			params.require(:offer).permit(
				:name,
				:allotment,
				:quantity,
				:start_t,
				:end_t,
				:price_cents,
				:description
			)
		end
end

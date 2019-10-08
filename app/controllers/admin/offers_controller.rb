class Admin::OffersController < ApplicationController
	load_resource :event
	load_and_authorize_resource :offer, through: :event

	def index
		@offers = @event.offers.order(created_at: :desc)
	end

	def create
		if @offer.save 
			render json: OfferSerializer.new(@offer).serialized_json 
		else
			head :bad_request
		end
	end

	def update
		if @offer.update(offer_params)
			head :no_content
		else
			head :bad_request
		end
	end

	def destroy
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
				:description,
				:active
			)
		end

		def current_ability
			@current_ability ||= AdminAbility.new(current_user)
		end

end

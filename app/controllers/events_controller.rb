class EventsController < ApplicationController
	load_and_authorize_resource

	def index
	end

	def show
		@order = @event.orders.build
		@order.order_items.build
	end

	def new
		@event.build_event_venue
		@event.offers.build
	end

	def create
		@event = Event.new(event_params)
		set_user_and_company
		if @event.save
			redirect_to @event
		else
			redirect_back(fallback_location: new_event_path)
		end
	end

	def edit
		@event.offers.build
	end

	def update
		if @event.update_attributes(event_params)
			redirect_to @event
		else
			redirect_back(fallback_location: new_event_path)
		end
	end

	private

		def set_user_and_company
			@event.user = current_user
			@event.company = current_user.company
		end

		def event_params
			params.require(:event).permit(
				:name, :headline, :image, :start_t, :end_t, :description,
				event_venue_attributes: [:id, :name, :address, :number, :complement, :neighborhood, :city, :state, :zipcode],
				offers_attributes: [:id, :name, :description, :price, :quantity, :start_t, :end_t]
			)
		end
end

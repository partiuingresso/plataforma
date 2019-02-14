class EventsController < ApplicationController
	load_and_authorize_resource

	def index
	end

	def new
	end

	def create
		puts event_params
		set_user_and_company
		if @event.create(event_params)
			redirect_to events_path
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
				:name, :image, :start_t, :end_t, :description,
				event_venue_attributes: [:name, :address, :number, :complement, :neighborhood, :city, :state, :zipcode]
			)
		end
end

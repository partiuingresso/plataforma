class EventsController < ApplicationController
	load_and_authorize_resource

	def index
	end

	def show
		@order = @event.orders.build
		@order.order_items.build
	end

	def new
		@event.build_address
		@event.offers.build
	end

	def create
		@event = Event.new(event_params)
		set_user_and_company
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Evento criado com sucesso.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
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

	def destroy
		if @event.orders.present?
			redirect_to events_path, alert: 'Evento não pode ser apagado.'
		else
			if @event.destroy
				redirect_to events_path, notice: 'Evento apagado.'
			end
		end
	end

	private

		def set_user_and_company
			@event.user = current_user
			@event.company = current_user.company
		end

		def event_params
			params.require(:event).permit(
				:name, :video, :headline, :hero_image, :content_image, :start_t, :end_t, :description,
				:features, :invite_text, address_attributes: [:id, :name, :address, :number, :complement, :district,
				:city, :state, :zipcode], offers_attributes: [:id, :name, :description, :price, :quantity, :start_t,
				:end_t], testimonial_images: []
			)
		end
end

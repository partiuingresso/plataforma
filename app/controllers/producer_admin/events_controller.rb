class ProducerAdmin::EventsController < ApplicationController
	load_and_authorize_resource

	def index
		@events = Event.accessible_by(current_ability).order(start_t: :asc)
	end

	def show
		if params[:offer].present?
			@offer = Offer.find(params[:offer])
			@all_orders = @offer.orders.order(created_at: :desc)
			@orders = Kaminari.paginate_array(@all_orders).page(params[:page]).per(10)
		else
			if search_params[:q].present?
				@all_orders = Order.where(event_id: @event).order(created_at: :desc)
				@search_order = @all_orders.search_order(search_params[:q])
				@orders = Kaminari.paginate_array(@search_order).page(params[:page]).per(10)
			else
				@all_orders = Order.where(event_id: @event).order(created_at: :desc)
				@orders = Kaminari.paginate_array(@all_orders).page(params[:page]).per(10)
			end
		end

		@total = @all_orders.approved.present? ? @all_orders.approved.sum(&:subtotal).format : "R$0,00"
		@total_pending = @all_orders.pending.present? ? @all_orders.pending.sum(&:subtotal).format : "R$0,00"
		@total_tickets = OrderItem.where(order_id: @all_orders.approved).sum('quantity')

		respond_to do |format|
			format.html
			format.csv { send_data @all_orders.to_csv, filename: "orders-#{Date.today}.csv" }
		end
	end

	def new
		@event.build_address
	end

	def create
		@event = Event.new(event_params)
		set_user_and_company
	    respond_to do |format|
	      if @event.save
	        format.html { redirect_to producer_admin_event_offers_path(@event), notice: 'Evento criado com sucesso.' }
	        format.json { render :show, status: :created, location: @event }
	      else
	        format.html { render :new }
	        format.json { render json: @event.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def edit; end

	def update
		if @event.update_attributes(event_params)
			redirect_to @event
		else
			redirect_back(fallback_location: new_event_path)
		end
	end

	def destroy
		if @event.orders.present?
			redirect_to producer_admin_events_path, alert: 'Evento não pode ser apagado.'
		else
			if @event.destroy
				redirect_to producer_admin_events_path, notice: 'Evento apagado.'
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
				:name, :video, :headline, :hero_image, :start_t, :end_t, :description,
				address_attributes: [:id, :name, :address, :number, :complement, :district,
				:city, :state, :zipcode]
			)
		end

	    def search_params
	      params.permit(:q)
	    end

	    def current_ability
	    	@current_ability ||= ProducerAdmin::EventAbility.new(current_user)
	    end
end

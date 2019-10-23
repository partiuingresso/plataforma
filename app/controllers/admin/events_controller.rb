class Admin::EventsController < ApplicationController
	load_resource :seller
	load_resource :event, through: :seller, shallow: true, except: [:index]
	authorize_resource

	def index
		@seller = Seller.find(params[:seller_id])
		@events = @seller.events.order(start_t: :asc)
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
		@event.user = current_user
	    respond_to do |format|
	      if @event.save
	        format.html { redirect_to admin_event_offers_path(@event), notice: 'Evento criado com sucesso.' }
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
			redirect_to admin_event_path(@event), notice: 'Evento atualizado com sucesso.'
		else
			redirect_back(fallback_location: edit_admin_event_path(@event))
		end
	end

	def destroy
		if @event.orders.present?
			redirect_to admin_seller_events_path(@event.seller), alert: 'Evento não pode ser apagado.'
		else
			if @event.destroy
				redirect_to admin_seller_events_path(@event.seller), notice: 'Evento apagado.'
			end
		end
	end

	private

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
			@current_ability ||= AdminAbility.new(current_user)
		end
end

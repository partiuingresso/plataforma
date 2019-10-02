class Admin::EventsController < ApplicationController
	load_resource except: [:index]
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

	private

	    def search_params
	      params.permit(:q)
	    end

		def current_ability
			@current_ability ||= AdminAbility.new(current_user)
		end
end

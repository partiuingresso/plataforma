class OrdersController < ApplicationController
	def index
	end

	def new
		@order = Order.new(order_params)
		@order.order_items = @order.order_items.select { |order_item| order_item.quantity > 0 }
		if @order.order_items.empty?
			redirect_back fallback_location: events_path
		else
			@order.order_items.each do |order_item|
				order_item.ticket_tokens.build
			end
		end
	end

	def create
		@order = Order.new(order_params)
		@order.user = current_user
		@order.order_items.each do |order_item|
			order_item.ticket_tokens.each do |ticket_token|
				ticket_token.code = "aaf0d0bab"
			end
		end

		if @order.save
			render plain: "OK"
		else
			render plain: "NOT GOOD"
		end

		wirecard_order = Wirecard::create_order @order
		puts wirecard_order.inspect
	end

	def show
	end

	private

	def order_params
		params.require(:order).permit(order_items_attributes: [:offer_id, :quantity, ticket_tokens_attributes: [:owner_name, :owner_email]])
	end

end

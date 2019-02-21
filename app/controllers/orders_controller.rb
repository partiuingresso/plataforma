class OrdersController < ApplicationController
	def index
	end

	def new
		@order = Order.new(order_params)
		@order.order_items.each do |order_item|
			order_item.ticket_tokens.build
		end
	end

	def create
		@order = Order.new(order_params)
		@order.user = current_user
		@order.order_items.each do |order_item|
			order_item.ticket_tokens.each do |ticket_token|
				ticket_token.code = "aaacfaf0d0bab"
				ticket_token.ticket_status_id = 2
			end
		end

		if @order.save
			render plain: "OK"
		else
			puts "***************************************************************"
			puts @order.errors.messages
			puts "***************************************************************"

			render plain: "NOT GOOD"
		end
	end

	def show
	end

	private

	def order_params
		params.require(:order).permit(order_items_attributes: [:offer_id, :quantity, ticket_tokens_attributes: [:owner_name, :owner_email]])
	end

end

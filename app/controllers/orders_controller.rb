class OrdersController < ApplicationController
	def index
	end

	def new
		@order = Order.new(orders_params)
	end

	def create
	end

	def show
	end

	private

	def orders_params
		params.require(:order).permit(order_items_attributes: [:offer_id, :quantity])
	end
end

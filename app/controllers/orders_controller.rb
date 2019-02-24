class OrdersController < ApplicationController
	def index
	end

	def new
		@order = Order.new(order_params)
		@order.order_items = @order.order_items.select { |order_item| order_item.quantity > 0 }
		@payment = Payment.new
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
				ticket_token.code = "jorge"
			end
		end

		if @order.save
			payment = Payment.new(payment_params)
			if Wirecard.process_checkout? @order, payment
				render plain: "OK"

				return
			else
				@order.destroy
			end
		end

		render plain: "NOT GOOD"
	end

	def show
	end

	private

	def order_params
		params.require(:order).permit(order_items_attributes: [:offer_id, :quantity, ticket_tokens_attributes: [:owner_name, :owner_email]])
	end

	def payment_params
		params.require(:payment).permit(
			:holder_fullname, :holder_cpf, :holder_birthdate, :holder_phone, :billing_address_street,
			:billing_address_number, :billing_address_complement, :billing_address_district,
			:billing_address_city, :billing_address_state, :billing_address_zipcode, :hash
		)
	end

end

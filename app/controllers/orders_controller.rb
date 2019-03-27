class OrdersController < ApplicationController
	authorize_resource

	def index
		@orders = current_user.orders.order(created_at: :desc)
	end

	def new
		@order = Order.new(params.require(:order).permit(:event_id, order_items_attributes: [:offer_id, :quantity]))
		order_items = params.require(:order).permit(:event_id, order_items_attributes: [:offer_id, :quantity])
		@order_form = OrderForm.new(order_items)
	end

	def create
		@order_form = OrderForm.new(order_params)
		@order_form.user = current_user

		if @order_form.save
			redirect_to success_path(number: @order_form.order.number)
		else
			render plain: @order_form.errors.messages
		end
	end

	def success
		@order = Order.find_by(number: params[:number])
	end

	def denied
	end

	private

	def order_params
		params.require(:order_form).permit(
			:event_id,
			payment_attributes: [
				:installment_count, :hash, :holder_fullname, :holder_birthdate, :holder_document, :holder_phone,
				billing_address_attributes: [
					:zipcode, :address, :number, :complement, :district, :city, :state
				]
			],
			order_items_attributes: [
				:offer_id, :quantity,
				ticket_tokens_attributes: [
					:owner_name, :owner_email
				]
			]
		)
	end
end

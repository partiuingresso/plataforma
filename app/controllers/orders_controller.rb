class OrdersController < ApplicationController
	load_and_authorize_resource

	def index
	end

	def new
		@order.order_items = @order.order_items.select { |order_item| order_item.quantity > 0 }
		unless @order.valid? && @order.order_items.present?
			redirect_back fallback_location: events_path and return
		end

		@payment = Payment.new
		@order.order_items.each do |order_item|
			order_item.ticket_tokens.build
		end
	end

	def create
		@order = Order.new(order_params)
		@order.user = current_user

		if @order.save
			payment_info = Payment.new(payment_params)
			order_payment = Wirecard.process_checkout? @order, payment_info
			if order_payment && order_payment.save
				render plain: "Compra feita com sucesso."
			else
				@order.destroy
				flash[:danger] = "Hmmmm.. não foi possível fazer o pagamento. Revise os campos enviados!"
				redirect_back(fallback_location: new_order_path)
			end
		else
			render plain: @order.errors.messages
		end
	end

	def show
	end

	private

	def order_params
		params.require(:order).permit(:event_id, order_items_attributes: [:offer_id, :quantity, ticket_tokens_attributes: [:owner_name, :owner_email]])
	end

	def payment_params
		p_params = params.require(:payment).permit(
			:installment_count, :holder_fullname, :holder_cpf, :billing_address_street,
			:billing_address_number, :billing_address_complement, :billing_address_district,
			:billing_address_city, :billing_address_state, :billing_address_zipcode, :hash
		)
		p_params[:installment_count] = p_params[:installment_count].to_i
		p_params[:holder_cpf].gsub! /[.-]/, ""
		date = params.delete(:date)
		p_params[:holder_birthdate] = date[:year] + "-" + date[:month] + "-" + date[:day]
		phone = params["phone"]
		p_params[:holder_phone_area_code] = /(\d\d)/.match(phone).to_s
		p_params[:holder_phone_number] = /(?:\d\s*)?[0-9]{4}-?[0-9]{4}/.match(phone).to_s.gsub(/\s+/, '').sub(/-/, '')
		p_params[:billing_address_zipcode] = p_params[:billing_address_zipcode].sub(/-/, '')

		return p_params
	end

end

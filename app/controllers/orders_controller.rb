class OrdersController < ApplicationController
	before_action :register_before_create, only: [:create]	
	load_and_authorize_resource

	def index
		@orders = current_user.orders.order(created_at: :desc)
	end

	def new
		@order.order_items = @order.order_items.select { |order_item| order_item.quantity > 0 && order_item.valid? }
		unless @order.order_items.present?
			redirect_back fallback_location: events_path and return
		end
		if current_user.nil?
			@user = User.new
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
				redirect_to success_path(number: @order.number)
			else
				@order.destroy
				redirect_back(fallback_location: new_order_path) 
			end
		else
			render plain: @order.errors.messages
		end
	end

	def success
		@order = Order.find_by(number: params[:number])
	end

	def denied
	end

	private

	def user_params
		params.require(:user).permit(:name, :email, :password)
	end

	def register_before_create
		if current_user.nil?
			@user = User.new(user_params)
			if @user.save
				sign_in @user
			else
				redirect_back(fallback_location: new_order_path)
			end
		end
	end

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

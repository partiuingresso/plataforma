class OrdersController < ApplicationController
	before_action :register_before_create, only: [:create]	
	authorize_resource

	def index
		@orders = current_user.orders.order(created_at: :desc)
	end

	def new
		@user = current_user || User.new
		@order = Order.new(order_params)
		@order.user = @user
		@order.order_items = @order.order_items.select { |order_item| order_item.quantity > 0 }
		unless @order.valid?
			redirect_back(fallback_location: event_path(@order.event)) and return
		end

		@order_form = OrderForm.new(order_params)
	end

	def create
		@order_form = OrderForm.new(order_form_params)
		@order_form.user = current_user

		if @order_form.save
			NotificationMailer.with(order: @order_form.order).order_received.deliver_later
			redirect_to success_path(number: @order_form.order.number)
		elsif @order_form.errors.include?(:checkout)
			@order = Order.new(order_form_params.slice(:event_id.to_s, :order_items_attributes.to_s))
			@order_form.payment.hash = nil
			flash.now[:alert] = @order_form.errors[:checkout][0]
			render :new
		else
			render plain: @order_form.errors.messages
		end
	end

	def success
		@order = Order.find_by(number: params[:number])
		authorize! :success, @order
	end

	def denied
	end

	def send_received_email
		@order = Order.find(params[:id])
		authorize! :send_received_email, @order

		NotificationMailer.with(order: @order).order_received.deliver_later
		respond_to do |format|
			format.json { render json: "ok", status: 200 }
		end
	end

	def send_confirmed_email
		@order = Order.find(params[:id])
		authorize! :send_confirmed_email, @order

		if @order.approved?
			NotificationMailer.with(order: @order).order_confirmed.deliver_later
		end
		respond_to do |format|
			format.json { render json: "ok", status: 200 }
		end
	end

	def send_ticket_email
		@order = Order.find(params[:id])
		authorize! :send_ticket_email, @order

		if @order.approved?
			@order.ticket_tokens.each do |t|
				unless t.owner_email == @order.user.email
					NotificationMailer.with(order: @order, ticket: t).order_ticket.deliver_later
				end
			end
		end
		respond_to do |format|
			format.json { render json: "ok", status: 200 }
		end
	end

	def send_refunded_email
		@order = Order.find(params[:id])
		authorize! :send_refunded_email, @order

		if @order.refunded?
			NotificationMailer.with(order: @order).order_reverted.deliver_later
		end
		respond_to do |format|
			format.json { render json: "ok", status: 200 }
		end
	end

	def send_denied_email
		@order = Order.find(params[:id])
		authorize! :send_denied_email, @order

		if @order.denied?
			NotificationMailer.with(order: @order).order_not_paid.deliver_later
		end
		respond_to do |format|
			format.json { render json: "ok", status: 200 }
		end
	end

	private

	def user_params
		params.require(:user).permit(:name, :email, :password)
	end

	def register_before_create
		if current_user.nil?
			@user = User.new(user_params)
			if User.exists?(email: @user.email)
				redirect_back(fallback_location: new_order_path, alert: "Usuário já existe. Faça o login antes de realizar a compra.") and return
			end
			if @user.save
				sign_in @user
			else
				redirect_back(fallback_location: new_order_path)
			end
		end
	end

	def order_params
		params.require(:order).permit(:event_id, order_items_attributes: [:offer_id, :quantity])
	end

	def order_form_params
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

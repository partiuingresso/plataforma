class OrdersController < ApplicationController
	protect_from_forgery prepend: true
	before_action :load_user, only: [:create]
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
		@user.name ||= @order_form.payment.holder_fullname || "Usuário Temporário"
		unless @user.persisted?
			register_user!
		end
		@order_form.user = @user

		if @order_form.save
			order = @order_form.order
			if order.free?
				NotificationMailer.with(order: order).free_order_confirmed.deliver_later
				order.ticket_tokens.each do |t|
					unless t.owner_email == order.user.email
						NotificationMailer.with(order: order, ticket: t).order_ticket.deliver_later
					end
				end
			else
				NotificationMailer.with(order: order).order_received.deliver_later
			end
			redirect_to success_path(number: @order_form.order.number)
		elsif @order_form.errors.include?(:checkout)
			@order = Order.new(order_form_params.slice(:event_id.to_s, :order_items_attributes.to_s))
			@order_form.payment.hash = nil
			render :new
		else
			redirect_to event_path(@order_form.order.event), alert: @order_form.errors.full_messages.to_sentence
		end
	end

	def success
		@order = Order.find_by(number: params[:number])
		authorize! :success, @order
		ab_finished(:"pdv#{@order.event.id}")
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

	def send_legacy_email
		@order = Order.find(params[:id])
		authorize! :send_legacy_email, @order

		if @order.approved?
			NotificationMailer.with(order: @order).legacy_tickets.deliver_later
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

	def register_user!
		@user.skip_confirmation_notification!
		@user.save!
	end

	def load_user
		@user = current_user || User.find_by_email(user_params["email"]) || User.new(user_params)
	end

	def user_params
		params.require(:user).permit(:email)
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

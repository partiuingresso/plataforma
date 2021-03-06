class OrdersController < ApplicationController
	protect_from_forgery prepend: true
	before_action :load_user, only: [:create]
	# load_and_authorize_resource :only => :show, :id_param => :number, :find_by => :number
	authorize_resource :only => :index

	def index
		@orders = Order.accessible_by(current_ability, :read)
			.order(created_at: :desc).includes(:ticket_tokens, :payment)
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
		unless @user.persisted?
			if @order_form.payment.present?
				@user.name ||= @order_form.payment.holder_fullname
			end
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
			redirect_to order_path(number: @order_form.order.number)
		elsif @order_form.errors.include?(:checkout)
			@order = Order.new(order_form_params.slice(:event_id.to_s, :order_items_attributes.to_s))
			@order_form.payment.hash = nil
			render :new
		else
			redirect_to event_path(@order_form.order.event), alert: @order_form.errors.full_messages.to_sentence
		end
	end

	def show
		@order = Order.find_by(number: params[:number])
		ab_finished(:"pdv#{@order.event.id}")
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
					:installment_count, :hash, :holder_fullname,
					:holder_birthdate, :holder_document, :holder_phone,
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

		def current_ability
			@current_ability ||= OrderAbility.new(current_user)
		end
end

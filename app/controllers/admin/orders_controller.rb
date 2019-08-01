class Admin::OrdersController < ApplicationController
	authorize_resource

	def index
		if search_params[:q].present?
			@all_orders = Order.all.order(created_at: :desc)
			@search_order = @all_orders.search_order(search_params[:q])
			@orders = Kaminari.paginate_array(@search_order).page(params[:page]).per(10)
		else
			@all_orders = Order.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).order(created_at: :desc)
			@orders = Kaminari.paginate_array(@all_orders).page(params[:page]).per(10)
		end
	end

	def send_received_email
		@order = Order.find(params[:id])

		NotificationMailer.with(order: @order).order_received.deliver_later
		respond_to do |format|
			format.json { render json: "ok", status: 200 }
		end
	end

	def send_confirmed_email
		@order = Order.find(params[:id])

		if @order.approved?
			if @order.free?
				NotificationMailer.with(order: @order).free_order_confirmed.deliver_later
			else
				NotificationMailer.with(order: @order).order_confirmed.deliver_later
			end
		end
		respond_to do |format|
			format.json { render json: "ok", status: 200 }
		end
	end

	def send_ticket_email
		@order = Order.find(params[:id])

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

		if @order.approved?
			NotificationMailer.with(order: @order).legacy_tickets.deliver_later
		end
		respond_to do |format|
			format.json { render json: "ok", status: 200 }
		end
	end

	def send_refunded_email
		@order = Order.find(params[:id])

		if @order.refunded?
			NotificationMailer.with(order: @order).order_reverted.deliver_later
		end
		respond_to do |format|
			format.json { render json: "ok", status: 200 }
		end
	end

	def send_denied_email
		@order = Order.find(params[:id])

		if @order.denied?
			NotificationMailer.with(order: @order).order_not_paid.deliver_later
		end
		respond_to do |format|
			format.json { render json: "ok", status: 200 }
		end
	end

	private
	
		def search_params
			params.permit(:q)
		end

		def current_ability
			@current_ability ||= AdminAbility.new(current_user)
		end
end

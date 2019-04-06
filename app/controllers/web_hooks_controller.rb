class WebHooksController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate
	layout false

	def webhooks
		resultado = Wirecard::Webhooks.listen(request) do |hook|
			hook.on(:order, :paid) do
				order_number = hook.resource.ownId.to_i
				order = Order.find_by(number: order_number)
				unless order.approved?
					order.approved!
					NotificationMailer.with(order: order).order_confirmed.deliver_later
					order.ticket_tokens.each do |t|
						unless t.owner_email == order.user.email
							NotificationMailer.with(order: order, ticket: t).order_ticket.deliver_later
						end
					end
				end
			end

			hook.on(:order, :not_paid) do
				order_number = hook.resource.ownId.to_i
				order = Order.find_by(number: order_number)
				if order.nil?
					# Pedidos em que o pagamento é cancelado na criação do pedido.
					return true
				else
					unless order.nil? || order.denied? || order.refunded?
						order.denied!
						NotificationMailer.with(order: order).order_not_paid.deliver_later
					end
				end
			end

			hook.on(:order, :reverted) do
				order_number = hook.resource.ownId.to_i
				order = Order.find_by(number: order_number)
				unless order.denied? || order.refunded?
					order.refunded!
					NotificationMailer.with(order: order).order_reverted.deliver_later
				end
			end

			hook.on(:transfer, :completed) do
				id = hook.resource.ownId.to_i
				transfer = Transfer.find(id)
				unless transfer.completed?
					transfer.completed!
				end
			end

			hook.on(:transfer, :failed) do
				id = hook.resource.ownId.to_i
				transfer = Transfer.find(id)
				unless transfer.failed?
					transfer.failed!
				end
			end

			hook.missing do |model, event|
				Rails.logger.warn "Não encontrado hook para o modelo #{model} e evento #{event}"
			end	
		end

		if resultado
			head :ok
			return
		end
		head :bad_request
	end

	private
		def authenticate
			ActiveSupport::SecurityUtils.secure_compare(request.headers["Authorization"], Wirecard::notification_token)
		end
end

class WebHooksController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate

	def webhooks
		resultado = Wirecard::Webhooks.listen(request) do |hook|
			# quando o moip envia dado sobre a criação de um pedido
			hook.on(:order, :paid) do
				# Fazer algo
				order_number = hook.resource.ownId.to_i
				order = Order.find_by(number: order_number)
				order.approved!
			end

			hook.on(:order, :not_paid) do
				# Fazer algo
				order_number = hook.resource.ownId.to_i
				order = Order.find_by(number: order_number)
				order.denied!
			end

			hook.on(:order, :reverted) do
				# Fazer algo
				order_number = hook.resource.ownId.to_i
				order = Order.find_by(number: order_number)
				order.refunded!
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

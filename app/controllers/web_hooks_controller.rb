class WebHooksController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate

	def webhooks
		resultado = Wirecard::Webhooks.listen(request) do |hook|
			# quando o moip envia dado sobre a criação de um pedido
			hook.on(:order, :created) do
				# Fazer algo
			end

			hook.on(:order, :paid) do
				# Fazer algo
				order_number = hook.resource.ownId.to_i
				order = Order.find_by(number: order_number)
				order.approved!
				order.save
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

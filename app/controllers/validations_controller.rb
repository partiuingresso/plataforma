class ValidationsController < ApplicationController
	def new
		@ticket_token = TicketToken.find_by_code(params[:code])
		unless @ticket_token.present?
			render json: "Ingresso não encontrado", status: :unprocessable_entity and return
		end

		respond_to do |format|
			if @ticket_token.ready?
				format.js
			elsif @ticket_token.authenticated?
				format.json { render json: "Ingresso já validado.", status: :unprocessable_entity }
			else
				format.json { render json: "Ingresso inválido.", status: :unprocessable_entity }
			end
		end
	end

	def create
		@ticket_token = TicketToken.find_by_code(validation_params[:code])
		unless @ticket_token.present?
			render json: "Ingresso não encontrado", status: :unprocessable_entity and return
		end

		@ticket_token.build_validation(user: current_user)

		respond_to do |format|
			if @ticket_token.ready? && @ticket_token.save
				format.js
				format.json { render json: "Validação feita!", status: :created }
			elsif @ticket_token.authenticated?
				format.json { render json: "Ingresso já validado.", status: :unprocessable_entity }
			else
				format.json { render json: "Erro ao validar ingresso.", status: :internal_server_error }
			end
		end
	end

	private
		def validation_params
			params.require(:ticket_token).permit(:code)
		end
end

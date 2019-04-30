class ValidationsController < ApplicationController
	def new
		@ticket_token = TicketToken.find_by_code(params[:code])
		unless @ticket_token.present?
			render json: "Ingresso não encontrado.", status: :unprocessable_entity and return
		end

		respond_to do |format|
			if @ticket_token.ready?
				format.js
			elsif @ticket_token.authenticated?
				@error_message = "Ingresso já validado."
				format.js { render status: :unprocessable_entity }
			else
				@error_message = "Algo deu errado."
				format.js { render status: :unprocessable_entity }
			end
		end
	end

	def create
		@ticket_token = TicketToken.find_by_code(validation_params[:code])
		unless @ticket_token.present?
			render json: "Ingresso não encontrado.", status: :unprocessable_entity and return
		end

		@ticket_token.build_validation(user: current_user)

		respond_to do |format|
			if @ticket_token.ready? && @ticket_token.save
				format.js
			elsif @ticket_token.authenticated?
				@error_message = "Ingresso já validado."
				format.js { render status: :unprocessable_entity }
			else
				@error_message = "Algo deu errado."
				format.js { render status: :unprocessable_entity }
			end
		end
	end

	private
		def validation_params
			params.require(:ticket_token).permit(:code)
		end
end

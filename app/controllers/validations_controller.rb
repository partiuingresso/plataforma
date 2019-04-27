class ValidationsController < ApplicationController
	def new
		@ticket_token = TicketToken.find(params[:ticket_id])
		respond_to do |format|
			format.js
		end
	end

	def create
		@ticket_token = TicketToken.find_by_code(validation_params[:code])
		if @ticket_token.present? && @ticket_token.ready?
			@validation = Validation.new({user: current_user})
			if @ticket_token.validation = @validation
				respond_to do |format|
					format.js
					format.json { render json: "Validação feita!", status: :created }
				end
			else
				render plain: "Algo deu errado!"
			end
		else
			render plain: "Erro na validação."
		end
	end

	private
		def validation_params
			params.require(:ticket_token).permit(:code)
		end
end

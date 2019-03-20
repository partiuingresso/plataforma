class TicketTokensController < ApplicationController
  authorize_resource

  def index
		@ticket_tokens = current_user.ticket_tokens
  end

  def new_validation
		@ticket_token = TicketToken.new
  end

  def create_validation
		@ticket_token = TicketToken.find_by_code(validation_params[:code])
		if @ticket_token.present? && @ticket_token.ready?
			@validation = Validation.new({user: current_user})
			if @ticket_token.validation = @validation
				respond_to do |format|
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

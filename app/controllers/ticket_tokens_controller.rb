class TicketTokensController < ApplicationController
  authorize_resource

  def index
		@ticket_tokens = current_user.ticket_tokens
  end

  def new_validation
    @event = Event.find(params[:id])

    if search_params[:q].present?
      @event_tickets = @event.ticket_tokens.search_ticket(search_params[:q])
      @effective_tickets = @event_tickets.ready + @event_tickets.authenticated
      @tickets = Kaminari.paginate_array(@effective_tickets).page(params[:page]).per(10)
    else
      @event_tickets = @event.ticket_tokens
      @effective_tickets = @event_tickets.ready + @event_tickets.authenticated
      @tickets = Kaminari.paginate_array(@effective_tickets).page(params[:page]).per(10)
    end

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

    def search_params
      params.permit(:q)
    end
end

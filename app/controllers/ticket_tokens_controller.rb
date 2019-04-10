class TicketTokensController < ApplicationController
  authorize_resource

  def index
    @tickets = current_user.ticket_tokens
		@ticket_tokens = Kaminari.paginate_array(@tickets.ready).page(params[:page]).per(9)
  end

  def show
    @ticket_token = current_user.ticket_tokens.find(params[:id])

    respond_to do |format|
      format.html { render :show }

      format.pdf do
        pdf = VoucherPdf.new(@ticket_token)
        send_data pdf.render,
          filename: "#{@ticket_token.owner_name}-#{@ticket_token.event.name}-PartiuIngresso.pdf",
          type: "application/pdf",
          disposition: :inline
      end
    end
  end

  def update
    @ticket_token = TicketToken.find(params[:id])
    if @ticket_token.update(update_params)
      respond_to do |format|
        format.json { render json: "ok", status: 200 }
      end
    else
      render alert: "Não foi possível salvar as alterações" and return
    end
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

    def update_params
      params.require(:ticket_token).permit(:owner_name, :owner_email)
    end

    def search_params
      params.permit(:q)
    end
end

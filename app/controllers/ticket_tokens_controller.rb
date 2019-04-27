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

  private
    def update_params
      params.require(:ticket_token).permit(:owner_name, :owner_email)
    end
end

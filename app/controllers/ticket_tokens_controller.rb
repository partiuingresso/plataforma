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
        if @ticket_token.order.payment.present?
          pdf = VoucherPdf.new(@ticket_token)
        else
          pdf = VoucherPdfDiscreet.new(@ticket_token)
        end
        send_data pdf.render,
          filename: "#{@ticket_token.owner_name}-#{@ticket_token.event.name}-PartiuIngresso.pdf",
          type: "application/pdf",
          disposition: :inline
      end
    end
  end

  private

    def current_ability
      @current_ability ||= TicketTokenAbility.new(current_user)
    end
end

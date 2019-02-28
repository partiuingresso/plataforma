class TicketTokensController < ApplicationController
  load_and_authorize_resource

  def index
    @ticket_tokens = current_user.ticket_tokens
  end
end

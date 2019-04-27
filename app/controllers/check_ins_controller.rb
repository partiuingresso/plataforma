class CheckInsController < ApplicationController
	def show
	    @event = Event.find(params[:id])

	    if search_params[:q].present?
	      event_tickets = @event.ticket_tokens.search_ticket(search_params[:q])
	      effective_tickets = event_tickets.authenticated + event_tickets.ready
	      @tickets = Kaminari.paginate_array(effective_tickets).page(params[:page]).per(10)
	    else
	      event_tickets = @event.ticket_tokens
	      effective_tickets = event_tickets.authenticated + event_tickets.ready
	      @tickets = Kaminari.paginate_array(effective_tickets).page(params[:page]).per(10)
	    end
	end

	private
	    def search_params
			params.permit(:q)
	    end
end

class EventsController < ApplicationController
	def show
		@event = Event.find(params[:id])
		@order = @event.orders.build
		@order.order_items.build
		@address_url = helpers.google_maps_url(@event.address)
	end
end

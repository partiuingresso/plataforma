class AdsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    @order = @event.orders.build
    @order.order_items.build
  end
end
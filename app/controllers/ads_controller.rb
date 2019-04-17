class AdsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    @order = @event.orders.build
    @order.order_items.build
  end

  def test_ab
    @event = event_path(params[:id])
    @ads = ads_path(params[:id])
    ab_test(:"pdv#{(params[:id])}", @event, @ads) do |pdv|
      redirect_to pdv
    end
  end

end
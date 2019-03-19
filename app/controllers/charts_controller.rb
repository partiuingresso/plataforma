class ChartsController < ApplicationController
  def sales_count
    @events = Event.where(company_id: current_user.company_id)
    @orders = Order.where(event_id: @events)
    render json: @orders.approved.group_by_day(:created_at, last: 28, format: "%d %b").count
  end

  def sales_value
    @events = Event.where(company_id: current_user.company_id)
    @orders = Order.where(event_id: @events)
    render json: @orders.approved.group_by_day(:created_at, last: 28, format: "%d %b").sum('subtotal_cents / 100')
  end

  def report_count
    offer = params[:offer]
    if offer.present?
      @offer = Offer.find(offer)
      @orders = @offer.orders
    else
      @orders = Order.where(event_id: params[:id])
    end
    render json: @orders.approved.group_by_day(:created_at).count
  end

  def report_value
    offer = params[:offer]
    if offer.present?
      @offer = Offer.find(offer)
      @orders = @offer.orders
    else
      @orders = Order.where(event_id: params[:id])
    end
    render json: @orders.approved.group_by_day(:created_at, format: "%d %b, %y").sum('subtotal_cents / 100')
  end
end
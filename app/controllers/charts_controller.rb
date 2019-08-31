class ChartsController < ApplicationController
  def sales_count
    @events = Event.where(seller_id: current_user.seller_id)
    @orders = Order.where(event_id: @events)
    render json: @orders.approved.group_by_day(:created_at, last: 28, format: "%d %b").count
  end

  def sales_value
    @events = Event.where(seller_id: current_user.seller_id)
    @orders = Order.where(event_id: @events)
    render json: @orders.approved.group_by_day(:created_at, last: 28, format: "%d %b").sum('subtotal_cents / 100')
  end

  def sales_tickets
    @events = Event.where(seller_id: current_user.seller_id)
    @orders = Order.where(event_id: @events)
    @tickets = OrderItem.where(order_id: @orders.approved)
    render json: @tickets.group_by_day(:created_at, last: 28, format: "%d %b").sum('quantity')
  end

  def all_sales_count
    @orders = Order.all
    render json: @orders.approved.group_by_day(:created_at, last: 28, format: "%d %b").count
  end

  def all_sales_value
    @orders = Order.all
    render json: @orders.approved.group_by_day(:created_at, last: 28, format: "%d %b").sum('subtotal_cents / 100')
  end

  def all_sales_tickets
    @orders = Order.all
    @tickets = OrderItem.where(order_id: @orders.approved)
    render json: @tickets.group_by_day(:created_at, last: 28, format: "%d %b").sum('quantity')
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

  def report_tickets
    offer = params[:offer]
    if offer.present?
      @offer = Offer.find(offer)
      @orders = @offer.orders
      @tickets = OrderItem.where(order_id: @orders.approved)
    else
      @orders = Order.where(event_id: params[:id])
      @tickets = OrderItem.where(order_id: @orders.approved)
    end
    render json: @tickets.group_by_day(:created_at).sum('quantity')
  end
end
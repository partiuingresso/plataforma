class CancelPendingOrderJob < ApplicationJob
  queue_as :orders

  def perform(order_id)
  	order = Order.find(order_id)
  	unless !order.pending?
  		order.denied!
		NotificationMailer.with(order: order).order_not_paid.deliver_later
  	end
  end
end

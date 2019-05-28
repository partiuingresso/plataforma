class CancelPendingOrderJob < ApplicationJob
  queue_as :orders

  def perform(order_id, payment_id)
  	order = Order.find(order_id)
  	unless !order.pending?
  		order.denied!
  		Wirecard::api.payment.void(payment_id)
  	end
  end
end

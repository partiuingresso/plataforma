namespace :order do
	desc "Updates order status and send the transitional emails"
	task :update_status, [:order_id, :order_moip_id] => :environment do |task, args|
		order_id = args[:order_id]
		order_moip_id = args[:order_moip_id]

		begin
			order = Order.find(order_id)
		rescue => e
			puts e.message

			return
		end

		puts "Order found..."

		puts "Fetching moip data..."
		wirecard_order = Wirecard::show_order(order_moip_id)

		if wirecard_order.status == "PAID"
			unless order.approved?
				puts "Changing order status to approved..."
				order.approved!

				puts "Sending order confirmation email..."
				NotificationMailer.with(order: order).order_confirmed.deliver_now
				order.ticket_tokens.each do |t|
					unless t.owner_email == order.user.email
						puts "Sending ticket token email..."
						NotificationMailer.with(order: order, ticket: t).order_ticket.deliver_now
					end
				end
			end
		elsif wirecard_order.status == "NOT_PAID"
			unless order.denied? || order.refunded?
				puts "Changing order status to denied..."
				order.denied!

				puts "Sending denied order email..."
				NotificationMailer.with(order: order).order_not_paid.deliver_now
			end
		end
	end
end
desc "Cancel an event."
task :cancel_event, [:event_id] => :environment do |task, args|
	event_id = args[:event_id]
	event = Event.find(event_id)
	puts "Obtendo informações necessárias no servidor da wirecard..."
	wirecard_orders = fetch_orders
	orders = event.orders.where(status: [:pending, :approved])
	puts "Pedidos processando ou aprovados encontrados: #{orders.size} "
	errors = []
	successful_count = 0
	orders.each do |order|
		order.refunded!
		moip_id = find_id(wirecard_orders, order.number)
		if moip_id.present?
			begin
				response = Wirecard::api.refund.create(moip_id)
				unless response.respond_to?(:status) && (response.status == "COMPLETED" || response.status == "REQUESTED")
					errors.push(order.number)
				end
				NotificationMailer.with(order: order).order_event_cancelled.deliver_now
				successful_count += 1
			rescue NotFoundError => e
				errors.push(order.number)
				puts e.message
			end
		else
			errors.push(order.number)
		end
		print '.'
	end
	puts ''

	if successful_count > 0
		puts "Email de cancelamento enviado e reembolso realizado com sucesso em #{successful_count} pedidos."
	end

	if errors.length > 0
		puts "Alguns pedidos não conseguiram ser reembolsados: (quantidade: #{errors.length})"
		errors.each do |err|
			puts err
		end
	end
end

def find_id(wirecard_orders, number)
	order = wirecard_orders.find do |o|
		o.own_id.to_i == number
	end

	return order&.id
end

def fetch_orders
	orders = []
	off = 0
	begin
		r = Wirecard::api.order.find_all(filters: { status: { in: ["WAITING", "PAID"] } }, limit: 500, offset: off ).orders
		orders += r
		off += 500
	end until r == []

	return orders
end

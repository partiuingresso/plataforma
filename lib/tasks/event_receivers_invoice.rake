task :event_receivers_invoice, [:event_id] => :environment do |task, args|
	event_id = args[:event_id]
	event = Event.find(event_id)
	puts "Obtendo informações necessárias no servidor da wirecard..."
	orders_moip_id = fetch_orders
	puts "Informações obtidas..."
	orders = event.orders.where(status: [:approved])
	puts "Pedidos aprovados encontrados: #{orders.size} "
	receivers = Hash[Seller.all.map {|c| [c.moip_id, 0]}]

	orders.each do |o|
		moip_id = orders_moip_id[o.number]
		unless moip_id.nil? || o.subtotal == 0
			receiver_id = find_receiver_id(orders_moip_id[o.number])
			receivers[receiver_id] += o.subtotal
			print "."
		end
	end

	puts ""

	receivers.each do |id, total|
		unless total == 0
			puts id
			puts total.format
		end
	end
end

def find_receiver_id(wirecard_order_id)
	order = Wirecard::api.order.show wirecard_order_id
	receiver = order.receivers.find {|r| r.type == "SECONDARY"}

	return receiver.moip_account.id
end

def fetch_orders
	all = []
	off = 0
	begin
		r = Wirecard::api.order.find_all(filters: { status: { in: ["PAID"] } }, limit: 500, offset: off ).orders
		all += r
		off += 500
	end until r == []

	orders = {}
	all.each do |o|
		orders[o.own_id.to_i] = o.id
	end

	return orders
end

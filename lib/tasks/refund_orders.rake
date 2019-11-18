task :refund_order_as_payor, [:order_numbers] => :environment do |task, args|
	order_numbers = args[:order_numbers].split(" - ")
	order_numbers.map! { |n| n.to_i }
	orders = Order.where(number: [order_numbers])
	puts "Obetendo informações da wirecard..."
	# Id wirecard dos pedidos pagos. Ex: orders_wirecard[1904030970679] == ORD-XYHIE76SKD9
	orders_wirecard = fetch_orders
	orders.each do |order|
		unless order.approved?
			msg = "Esse pedido não pode ser reembolsado porque não recebeu um pagamento ou"\
			" já foi reembolsado anteriormente."
			raise ArgumentError, msg
		end
		order_moip_id = orders_wirecard[order.number]
		refund_order_as_payor(order, order_moip_id)
	end
end

def refund_order_as_payor(order, order_moip_id)
	# Id do receiver. Ex: MPA-576AD24B6106
	receiver_id = find_receiver_id(order_moip_id)
	seller = Seller.find_by!(moip_id: receiver_id)
	puts "Transferindo o subtotal do pedido para a conta do produtor #{seller.name}..."
	# Transfere o valor para a conta do produtor.
	response = Wirecard::transfer_to seller, order.subtotal_cents
	unless response.respond_to?(:status) && response.status == "COMPLETED"
		raise StandardError, "Erro ao transferir fundos para a conta do produtor."
	end
	puts "Soliciando o reembolso do pedido #{order.number}..."
	# Solicita o reembolso do pedido
	response = Wirecard::api.refund.create(order_moip_id)
	unless response.respond_to?(:status) && (response.status == "COMPLETED" || response.status == "REQUESTED")
		raise StandardError, "Erro ao solicitar o reembolso do pedido."\
			" Importante:"\
			" O valor transferido para a conta do produtor não foi retornada a conta wirecard da PartiuIngresso."
	end
	puts "Enviando email de notificação de reemolso ao cliente #{order.user.email}..."
	NotificationMailer.with(order: order).order_reverted.deliver_now
	puts "DONE."
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

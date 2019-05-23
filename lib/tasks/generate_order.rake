desc "Generate approved order."
task :generate_order => :environment do
	print "Usuário: "
	user_email = $stdin.gets.chomp
	user = User.find_by_email(user_email)
	until user.present?
		print "Usuário não encontrado. Tente novamente: "
	end

	events = Event.all
	print_menu_options(events.collect { |event| "#{event.name} - #{event.address.city}/#{event.address.state}" })
	print "Selecione um evento: "
	begin
		answer = $stdin.gets.chomp
	end until /\A[0-9]+\z/.match?(answer) && answer.to_i >= 1 && answer.to_i <= events.size
	answer = answer.to_i

	event = events[answer - 1]
	order = user.orders.build(status: :approved, event: event)

	offers = event.offers
	begin
		print_menu_options(offers.collect { |offer| "#{offer.name} - Quantidade disponível: #{offer.available_quantity}" })
		print "Selecione um oferta: "
		begin
			answer = $stdin.gets.chomp
		end until /\A[0-9]+\z/.match?(answer) && answer.to_i >= 1 && answer.to_i <= offers.size
		answer = answer.to_i

		offer = offers[answer - 1]

		print "Selecione a quantidade: "
		begin
			answer = $stdin.gets.chomp
		end until /\A[0-9]+\z/.match?(answer) && answer.to_i >= 1 && answer.to_i <= [offer.available_quantity, 5].min
		quantity = answer.to_i

		order_item = order.order_items.build(offer: offer, quantity: quantity)

		quantity.times do
			print "Nome do participante: "
			owner_name = $stdin.gets.chomp

			print "Email do participante: "
			owner_email = $stdin.gets.chomp
			order_item.ticket_tokens.build(owner_name: owner_name, owner_email: owner_email, status: :ready)
		end

		print "Mais item de pedido?(y/N) "
		begin
			more_order_item = $stdin.gets.chomp
		end until /\A[yN]\z/.match?(more_order_item)
	end while more_order_item == "y"

	if order.save
		puts "Pedido criado com sucesso! :)"
		if user.id == 2
			NotificationMailer.with(order: order).legacy_tickets.deliver_now
		else
			order.ticket_tokens.each do |ticket|
				NotificationMailer.with(order: order, ticket: ticket).order_ticket.deliver_now
			end
		end
	else
		puts "Não foi possível fazer o pedido."
	end
end

def print_menu_options(list)
	separator = "-" * 50
	puts separator
	list.each_with_index do |elem, index|
		item_number = index + 1
		puts "#{item_number}. #{elem}"
	end
	puts separator
end

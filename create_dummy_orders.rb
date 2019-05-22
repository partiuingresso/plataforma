50.times do |index|
	user = User.new(name: Faker::Name.unique.name, email: Faker::Internet.unique.email, password: 'usuarioteste')
	user.skip_confirmation!

	event = Event.find(1)

	order = user.orders.build(status: :approved, event_id: 1)
	o1 = order.order_items.build(offer: event.offers[index%event.offers.size], quantity: 5)
	o2 = order.order_items.build(offer: event.offers[(index+1)%event.offers.size], quantity: 5)

	5.times do
		o1.ticket_tokens.build(owner_name: Faker::TvShows::GameOfThrones.unique.character, owner_email: Faker::Internet.email, status: :ready)
		o2.ticket_tokens.build(owner_name: Faker::TvShows::GameOfThrones.unique.character, owner_email: Faker::Internet.email, status: :ready)
	end

	order.build_payment(
		amount_cents: order.subtotal_cents * (1 + Business::Finance::ServiceFee),
		card_brand: "MASTERCARD",
		card_number_last_4: 8884,
		service_fee: Business::Finance::ServiceFee
	)

	user.save!
end
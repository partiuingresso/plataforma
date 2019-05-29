desc "Calculates event's revenue."
task :event_revenue, [:event_id] => :environment do |task, args|
	WIRECARD_FIXED_FEE = 69
	WIRECARD_FEE = {
		1 => 0.0419,
		2 => 0.0519,
		3 => 0.0549,
		4 => 0.0599,
		5 => 0.0649,
		6 => 0.0699,
		7 => 0.0799,
		8 => 0.0849,
		9 => 0.0899,
		10 => 0.0949,
		11 => 0.0989,
		12 => 0.1049
	}

	event_id = args[:event_id]
	event = Event.find(event_id)
	orders = event.orders.includes(:payment).approved.where("orders.user_id != 2")

	incomes = event.orders.collect do |order|
		payment = order.payment
		if payment.present?
			total_amount = payment.amount_cents
			wirecard_amount = WIRECARD_FIXED_FEE + (total_amount * WIRECARD_FEE[payment.installment_count]).round
			company_amount = order.read_attribute(:subtotal_cents)
			income_amount = total_amount - (wirecard_amount + company_amount)
		else
			0
		end
	end
	total = incomes.sum

	puts "Evento: #{event.name} #{event.address.city}/#{event.address.state}"
	puts "Receita do evento: #{Money.new(total).format}"
end

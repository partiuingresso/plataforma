desc "Generate invoice csv"
task :generate_invoice, [:month] => :environment do |task, args|
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

	month = args[:month].to_i

	start_date = DateTime.new(2019, month, 1)
	end_date = DateTime.new(2019, month + 1, 1)

	companies = Company.all
	invoice = {}
	companies.each do |company|
		orders = company.orders.includes(:payment).approved.where(
			"orders.updated_at >= :start_date AND orders.updated_at < :end_date",
			{ start_date: start_date, end_date: end_date }
		)
		incomes = orders.collect do |order|
			payment = order.payment
			total_amount = payment.amount_cents
			wirecard_amount = total_amount * WIRECARD_FEE[payment.installment_count]
			company_amount = order.read_attribute(:subtotal_cents)
			income_amount = total_amount - (wirecard_amount + company_amount)
		end
		invoice[company.name] = incomes.sum
	end

	CSV.open(Rails.root.join("./invoice_19_#{month}.csv"), "w") do |csv|
		csv << ["Organizador", "Total"]
		invoice.each do |company_name, income|
			csv << [company_name, Money.new(income).format]
		end
	end
end

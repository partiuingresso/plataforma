namespace :db do
	namespace :seed do
		namespace :legacy_sale do
			Dir[Rails.root.join('lib', 'assets', 'files', 'legacy_sales', '*.csv')].each do |filename|
				task_name = File.basename(filename, '.csv')
				desc "Loads the seed data from lib/assets/files/legacy_sales/#{task_name}.csv"
				task task_name.to_sym, [:admin_id, :event_id] => :environment do |task, args|
					main(filename, args)
				end
			end
		end
	end
end

def main(filename, args)
	begin
		admin_user = User.find(args[:admin_id])
		event = Event.find(args[:event_id])
	rescue => e
		puts e.message
		return
	end

	name_idx = 0
	email_idx = 2
	quantity_idx = 4
	offer_idx = 3

	sales = {}

	puts "Reading filename..."
	CSV.foreach(filename, { col_sep: ";", headers: true }) do |row|
		offer_name = row[offer_idx].gsub(/\s+\Z/, "")
		owner_name = row[name_idx].gsub(/\s+\Z/, "")
		email = row[email_idx].downcase
		quantity = row[quantity_idx].to_i

		sales[email] ||= { name: owner_name, items: [] }
		if sales[email][:items].collect { |item| item[:offer_name] }.include? offer_name
			sales[email][:items].map do |item|
				if item[:offer_name] == offer_name
					item[:quantity] += quantity
				end
			end
		else
			sales[email][:items].push({offer_name: offer_name, quantity: quantity})
		end
	end

	puts "Seeding data..."
	sales.each do |email, sale_info|
		owner_name = sale_info[:name]
		order = Order.new(user: admin_user, status: :approved, event: event)

		sale_info[:items].each do |item|
			offer_name = item[:offer_name]
			quantity = item[:quantity]

			offer = Offer.find_by_name(offer_name) || Offer.new(
				name: offer_name,
				event: event,
				quantity: 0,
				available_quantity: 0,
				start_t: DateTime.now,
				price_cents: 0
			)
			offer.quantity += quantity
			offer.available_quantity += quantity
			offer.save!

			order_item = order.order_items.build(offer: offer.reload, quantity: quantity)
			quantity.times do
				order_item.ticket_tokens.build(owner_name: owner_name, owner_email: email, status: :ready)
			end
		end

		unless order.valid?
			puts order.errors.messages and return
		end
		order.save!
	end

	puts "DONE :)"
end

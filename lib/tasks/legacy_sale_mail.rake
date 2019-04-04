namespace :legacy_sale do
	desc "Sends tickets emails related to legacy sales of specified event id"
	task :tickets_notification, [:event_id] => :environment do |task, args|
		event_id = args[:event_id]
		begin
			event = Event.find(event_id)
		rescue => e
			puts e.message
			return
		end

		event.orders.each do |order|
			NotificationMailer.with(order: order).legacy_tickets.deliver_now
		end
	end

	desc "Resends tickets email for each owner email in the specified csv file"
	task :resend_tickets_notification, [:filename] => :environment do |task, args|
		orders = {}
		puts "Reading file..."
		begin
			filename = args[:filename]
			CSV.foreach(filename, { col_sep: ";", headers: true }) do |row|
				email = row[0].downcase
				ticket_token = TicketToken.find(owner_email: email)
				orders[email] ||= ticket_token.order
			end
		rescue => e
			puts e.message
			return
		end

		puts "Sending emails..."
		orders.values.each do |order|
			NotificationMailer.with(order: order).legacy_tickets.deliver_now
		end

		puts "DONE :)"
	end
end

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
end

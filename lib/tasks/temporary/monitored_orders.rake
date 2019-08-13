require 'sidekiq/api'

namespace :monitored_orders do
  desc "Run monitored orders jobs"
  task run: :environment do
  	queue = Sidekiq::Queue.new("orders")
	count = 0

  	queue.each do |job|
  		order_id = job["args"][0]["arguments"][0]
  		order = Order.find(order_id)
  		remaining_time = ((order.event.start_t - order.created_at.to_datetime) * 24 * 60).round
  		if (order.created_at.to_datetime + waiting_time(remaining_time)) > DateTime.now
  			job.delete
  			meta = job.args.first
			klass = meta["job_class"].constantize
			klass.new(*meta['arguments']).perform_now

			count += 1
  		end
  	end

	puts count.to_s + " pedidos rodados."
	puts "DONE :)"
  end
end

def waiting_time(remaining_time)
	((1435.0 / (4320 ** 2)) * remaining_time ** 2 + 5).round.minutes
end

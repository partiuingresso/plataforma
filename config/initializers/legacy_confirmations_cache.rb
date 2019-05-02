$confirmation_cache = ActiveSupport::Cache::FileStore.new Rails.root.dirname.join("legacy_confirmation_cache")

unless $confirmation_cache.exist?("confirmations")
	confirmation_hash = {}

	legacy_orders = Order.where(user_id: 2, status: :approved)
	legacy_orders.each do |order|
		confirmation_hash[order.number] = false
	end
	$confirmation_cache.write("confirmations", confirmation_hash)
end

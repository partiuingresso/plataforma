confirmation_hash = {}

legacy_orders = Order.where(user_id: 3, status: :approved)
legacy_orders.each do |order|
	confirmation_hash[order.number] = false
end

$confirmation_cache = ActiveSupport::Cache::MemoryStore.new
$confirmation_cache.write("confirmations", confirmation_hash)

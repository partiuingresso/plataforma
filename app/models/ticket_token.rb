class TicketToken < ApplicationRecord
	enum status: { pending: "pending", ready: "ready",
		 authenticated: "authenticated", expired: "expired", cancelled: "cancelled" }
	has_one :validation
	belongs_to :order_item

	after_initialize :default_values

	private

		def default_values
			self.status ||= :pending
		end
end

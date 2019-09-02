class Transfer < ApplicationRecord
	enum status: { requested: "requested", completed: "completed", failed: "failed", reversed: "reversed" }
	belongs_to :seller
	belongs_to :bank_account

	monetize :fee_cents, numericality: { greater_than_or_equal_to: 0 }
	monetize :amount_cents, numericality: { greater_than_or_equal_to: 0 }

	after_initialize :set_defaults

	private
		def set_defaults
			self.status ||= :requested
			self.fee ||= 0
		end
end

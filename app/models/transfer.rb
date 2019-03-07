class Transfer < ApplicationRecord
	enum status: { requested: "requested", completed: "completed", failed: "failed", reversed: "reversed" }
	belongs_to :company
	belongs_to :bank_account

	monetize :fee_cents
	monetize :amount_cents

	after_initialize :set_defaults

	private
		def set_defaults
			self.status ||= :requested
		end
end

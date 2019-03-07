class Transfer < ApplicationRecord
	enum status: { requested: "requested", completed: "completed", failed: "failed", reversed: "reversed" }
	belongs_to :company
	belongs_to :bank_account

	after_initialize :set_defaults

	private
		def set_defaults
			self.status ||= :requested
		end
end

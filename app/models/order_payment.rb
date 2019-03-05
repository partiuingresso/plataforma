class OrderPayment < ApplicationRecord
	belongs_to :order

	monetize :amount_cents

	after_initialize :set_defaults

	private

		def set_defaults
			self.service_fee ||= Business::Finance::ServiceFee
		end
end

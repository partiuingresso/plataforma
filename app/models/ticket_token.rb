class TicketToken < ApplicationRecord
	include PgSearch
	pg_search_scope :search_ticket,
									against: [:owner_name],
									using: {
										tsearch: {any_word: true, prefix: true}
									}

	enum status: { pending: "pending", ready: "ready",
		 authenticated: "authenticated", expired: "expired", cancelled: "cancelled" }
	has_one :validation
	belongs_to :order_item
	has_one :order, through: :order_item
	has_one :user, through: :order_item
	has_one :offer, through: :order_item
	has_one :event, through: :offer

	has_secure_token :code

	scope :ready, -> { where(status: :ready) }

	validates :owner_name, presence: true
	validates :owner_email, format: { with: URI::MailTo::EMAIL_REGEXP }

	after_initialize :default_values

	require 'rqrcode'

	def qr
		RQRCode::QRCode.new(self.code, :size => 5, :level => :h )
	end

	def validation=(validation)
		self.status = :authenticated
		super
	end

	private

		def default_values
			self.status ||= :pending
		end
end

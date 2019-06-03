class TicketToken < ApplicationRecord
	require 'rqrcode'
	include PgSearch
	pg_search_scope :search_ticket,
									associated_against: {
										order: :number
									},
									against: :owner_name,
									using: {
										tsearch: {any_word: true}
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

	validates :owner_name, presence: true
	validates :owner_email, format: { with: URI::MailTo::EMAIL_REGEXP }

	after_initialize :default_values
	before_save :check_validation


	scope :not_cancelled, -> { where('status != ?', :cancelled) }

	def qr
		RQRCode::QRCode.new(self.code, :size => 5, :level => :h )
	end

	private

		def check_validation
			if self.validation.present?
				self.status = :authenticated
			end
		end

		def default_values
			self.status ||= :pending
		end
end

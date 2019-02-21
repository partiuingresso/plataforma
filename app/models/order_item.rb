class OrderItem < ApplicationRecord
  belongs_to :offer
  belongs_to :order
  has_many :ticket_tokens
  has_one :event, through: :offer

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :offer_cannot_be_from_other_event

  private

	def offer_cannot_be_from_other_event
		if event.present? && order.order_items.length > 0 && event != order.event
			errors.add(:event, "one order can't have order items related to different events")
		end
	end

end

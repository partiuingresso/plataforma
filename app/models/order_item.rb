class OrderItem < ApplicationRecord
  belongs_to :offer
  belongs_to :order
  has_many :ticket_tokens
  has_one :event, through: :offer

  accepts_nested_attributes_for :ticket_tokens

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :offer_cannot_be_from_other_event
  validate :quantity_cannot_be_different_to_valid_and_used_tokens_count

  def ticket_tokens_not_cancelled
    ticket_tokens.select { |ticket_token| !ticket_token.cancelled? }
  end

  private

    def quantity_cannot_be_different_to_valid_and_used_tokens_count
      if ticket_tokens.present? && self.quantity != ticket_tokens_not_cancelled.length
        errors.add(:quantity, "can't mismatch the number of valid and used ticket tokens")
      end
    end

    def offer_cannot_be_from_other_event
      if event.present? && order.order_items.length > 0 && event != order.event
        errors.add(:event, "one order can't have order items related to different events")
      end
    end
end

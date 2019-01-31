class TicketToken < ApplicationRecord
  belongs_to :order
  belongs_to :ticket_status
  has_one :validation
  belongs_to :order_item
end

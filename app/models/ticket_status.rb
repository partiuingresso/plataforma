class TicketStatus < ApplicationRecord
  has_many :ticket_tokens
end

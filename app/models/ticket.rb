class Ticket < ApplicationRecord
  belongs_to :offer
  belongs_to :order_item
  has_many :ticket_tokens
end

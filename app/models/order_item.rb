class OrderItem < ApplicationRecord
  belongs_to :offer
  belongs_to :order
  has_many :ticket_tokens
  has_one :event, through: :offer

end

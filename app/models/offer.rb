class Offer < ApplicationRecord
  belongs_to :event
  has_many :order_items
  has_many :tickets

  default_scope { where(active: true) }
end

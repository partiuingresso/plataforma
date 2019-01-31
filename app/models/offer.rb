class Offer < ApplicationRecord
  belongs_to :event
  has_many :order_items

  default_scope { where(active: true) }
end

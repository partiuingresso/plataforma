class Event < ApplicationRecord
  belongs_to :company
  has_many :offers
  belongs_to :event_venue
end

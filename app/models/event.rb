class Event < ApplicationRecord
  belongs_to :company
  belongs_to :user
  belongs_to :event_venue
  has_many :offers
end

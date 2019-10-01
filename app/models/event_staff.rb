class EventStaff < ApplicationRecord
	self.table_name = 'event_staff'
    has_one :user, as: :actor
	belongs_to :event
end

class Event < ApplicationRecord
	belongs_to :company
	belongs_to :user
	belongs_to :event_venue
	has_many :offers
	has_one_attached :image

	validates :name, presence: true
	validates :image, presence: true
	validates :start_t, presence: true
	validate :end_date_cannot_be_before_start

	validates_associated :event_venue

	accepts_nested_attributes_for :event_venue

	def end_date_cannot_be_before_start
		if end_t.present? && end_t < start_t
			errors.add(:end_t, "can't be before start date")
		end
	end
end

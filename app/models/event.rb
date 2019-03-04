class Event < ApplicationRecord
	belongs_to :company
	belongs_to :user
	belongs_to :address
	has_many :offers, dependent: :destroy
	has_many :orders
	has_one_attached :hero_image
	has_one_attached :content_image
	has_many_attached :testimonial_images

	validates :name, presence: true, length: { maximum: 150 }
	validates :headline, length: { maximum: 200 }, allow_blank: true
	validates :description, length: { maximum: 10000 }, allow_blank: true
	validates :start_t, presence: true
	validate :end_date_cannot_be_before_start

	validates_associated :address

	accepts_nested_attributes_for :address
	accepts_nested_attributes_for :offers

	def end_date_cannot_be_before_start
		if end_t.present? && end_t < start_t
			errors.add(:end_t, "can't be before start date")
		end
	end

	def self.to_happen
		Event.all.select { |event| event.start_t >= DateTime.now }
	end
end

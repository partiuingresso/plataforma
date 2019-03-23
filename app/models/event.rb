class Event < ApplicationRecord
	include PgSearch
	pg_search_scope :search_by_name,
									against: :name,
									using: {
										tsearch: {any_word: true, prefix: true}
									}

	belongs_to :company
	belongs_to :user
	belongs_to :address
	has_many :offers, dependent: :destroy
	has_many :orders
	has_many :order_items, through: :offers
	has_many :ticket_tokens, through: :order_items
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

	after_destroy :destroy_attached_files

	def end_date_cannot_be_before_start
		if end_t.present? && end_t < start_t
			errors.add(:end_t, "can't be before start date")
		end
	end

	def self.to_happen(margin = 0)
		Event.all.select { |event| event.start_t >= margin.hours.from_now }
	end

	def self.history
		Event.all.select { |event| event.start_t < DateTime.now }
	end

	private

		def destroy_attached_files
			hero_image.purge
			content_image.purge
			testimonial_images.purge
		end
end

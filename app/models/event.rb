class Event < ApplicationRecord
	include PgSearch
	pg_search_scope :search_by_name, associated_against: {
		address: [:name, :city, :state]
		},
		against: :name,
		using: {
			tsearch: {any_word: true, prefix: true}
		}

	belongs_to :seller
	belongs_to :user
	has_many :staff, class_name: :EventStaff
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

	after_destroy :destroy_attached_files

	scope :available, -> {
		joins(:offers)
		.merge(Offer.available).order(start_t: :asc)
		.distinct
	}

	scope :available_to_happen, -> {
		merge(available).where("events.start_t > ?", Date.today)
	}

	def self.highlights
		all = Event.available_to_happen.includes(:offers)
		closest = all.select { |event| event.start_t <= 10.days.from_now }
		best_sellers = all.select { |event| event.sold >= 1000 } - closest

		(closest.take(4) + best_sellers.take(4) + all).uniq.take(8)
	end

	def self.to_happen(margin = 0)
		Event.all.select { |event| DateTime.now < (event.start_t + margin.hours) }
	end

	def self.history
		Event.all.select { |event| event.start_t < DateTime.now }
	end

	def end_date_cannot_be_before_start
		if end_t.present? && end_t < start_t
			errors.add(:end_t, "can't be before start date")
		end
	end

	def sold
		offers.collect { |offer| offer.sold }.sum
	end

	def unavailable?
		!available?
	end

	def running_out?
		total = offers.collect { |offer| offer.quantity }.sum
		available = offers.collect { |offer| offer.available_quantity }.sum

		available.to_f / total <= 0.1
	end

	private

		def destroy_attached_files
			hero_image.purge
			content_image.purge
			testimonial_images.purge
		end
end

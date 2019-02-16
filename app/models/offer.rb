class Offer < ApplicationRecord
	belongs_to :event
	has_many :order_items

	validates :name, presence: true, length: { maximum: 150 }
	validates :description, length: { maximum: 500 }, allow_blank: true
	validates :price, presence: true, numericality: { less_than: (10 ** 10) }
	validates :quantity, presence: true, numericality: { only_integer: true }
	validates :available_quantity, presence: true, numericality: { only_integer: true }
	validate :available_quantity_cannot_be_greater_than_quantity
	validates :start_t, presence: true
	validate :end_date_cannot_be_before_start

	after_initialize :default_values

	private

		def available_quantity_cannot_be_greater_than_quantity
			if quantity.present? && available_quantity.present? && available_quantity > quantity
				errors.add(:available_quantity, "can't be greater than quantity")
			end
		end

		def end_date_cannot_be_before_start
			if end_t.present? && end_t < start_t
				errors.add(:end_t, "can't be before start date")
			end
		end

		def default_values
			self.available_quantity ||= self.quantity unless self.quantity.nil?
		end
end

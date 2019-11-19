class Offer < ApplicationRecord
	belongs_to :event
	has_many :order_items
	has_many :orders, through: :order_items

	scope :available, -> {
		where(
			"offers.active AND offers.start_t <= :now AND (offers.end_t IS NULL OR offers.end_t > :now)",
			{ now: DateTime.now }
		)
	}

	scope :free, -> { where(price_cents: 0) }
	scope :costly, -> { where("price_cents > 0") }

	validates :name, presence: true, length: { maximum: 150 }
	validates :description, length: { maximum: 500 }, allow_blank: true
	validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
	validates :sold, presence: true, numericality: { only_integer: true }
	validate :sold_cannot_be_greater_than_quantity
	validates :start_t, presence: true
	validates :end_t, presence: true
	validate :end_date_cannot_be_before_start
	validate :price_cannot_change_if_sold, on: :update

	monetize :price_cents
	monetize :fee_cents
	monetize :price_with_service_fee_cents

	def fee_cents
		self.price_cents * Business::Finance::ServiceFee
	end

	def price_with_service_fee_cents
		self.price_cents + fee_cents
	end

	def free?
		price == 0
	end

	def name_with_allotment
		self.name + " - Lote: " + self.allotment.to_s
	end

	def available_quantity
		self.quantity - self.sold
	end

	def available?
		active? && DateTime.now >= start_t && (end_t.nil? || DateTime.now < end_t)
	end

	def unavailable?
		!self.available?
	end

	def expired?
		end_t.present? && end_t < DateTime.now
	end

	private

		def sold_cannot_be_greater_than_quantity
			if quantity.present? && sold.present? && sold > quantity
				errors.add(:sold, "can't be greater than quantity")
			end
		end

		def end_date_cannot_be_before_start
			if end_t.present? && end_t < start_t
				errors.add(:end_t, "can't be before start date")
			end
		end

		def price_cannot_change_if_sold
			if price_cents_changed? && sold > 0
				errors.add(:price_cents, "can't change after sold")
			end
		end
end

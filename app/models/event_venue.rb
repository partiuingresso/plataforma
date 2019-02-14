class EventVenue < ApplicationRecord
  has_many :event

  validates :name, presence: true, length: { maximum: 150 }
  validates :address, presence: true, length: { maximum: 150 }
  validates :number, presence: true, length: { maximum: 10 }, numericality: { only_integer: true }
  validates :complement, length: { maximum: 50 }, allow_blank: true
  validates :neighborhood, presence: true, length: { maximum: 100 }
  validates :city, presence: true, length: { maximum: 100 }
  validates :state, presence: true, length: { maximum: 100 }
  validates :zipcode, presence: true, format: { with: /\A\d{5}-\d{3}\Z/,
		message: "only allows cep format" }
end

class Address < ApplicationRecord
  has_many :event

  validates :name, presence: true, length: { maximum: 150 }
  validates :address, presence: true, length: { maximum: 150 }
  validates :number, presence: true
  validates :complement, length: { maximum: 50 }, allow_blank: true
  validates :district, presence: true, length: { maximum: 100 }
  validates :city, presence: true, length: { maximum: 100 }
  validates :state, presence: true, length: { maximum: 100 }
  validates :zipcode, presence: true, format: { with: /\A\d{5}-\d{3}\Z/,
		message: "only allows cep format" }
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, allow_blank: true
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_blank: true

  geocoded_by :full_address
  after_validation :geocode

  def full_address
    [name, address, number, city, state, zipcode].compact.join(', ')
  end
end

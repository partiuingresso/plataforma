class Address < ApplicationRecord
  has_many :event

  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, allow_blank: true
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_blank: true

  geocoded_by :full_address
  after_validation :geocode

  def full_address
    [name, address, number, city, state, zipcode].compact.join(', ')
  end
end

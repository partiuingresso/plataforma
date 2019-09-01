class Company < ApplicationRecord
	belongs_to :seller
	belongs_to :address

	validates :name, presence: true
	validates :business_name, presence: true
	validates :document_number, presence: true
	validates :phone_area_code, presence: true
	validates :phone_number, presence: true

	accepts_nested_attributes_for :address
end

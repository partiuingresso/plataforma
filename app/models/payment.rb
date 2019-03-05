class Payment
	include ActiveModel::Model
	include ActiveModel::Validations

	# Encrypted Credit Card Number
	attr_accessor :hash
	attr_accessor :installment_count

	# Holder information
	attr_accessor :holder_fullname
	attr_accessor :holder_cpf
	attr_accessor :holder_birthdate
	attr_accessor :holder_phone_area_code
	attr_accessor :holder_phone_number

	# Billing Address
	attr_accessor :billing_address_street
	attr_accessor :billing_address_number
	attr_accessor :billing_address_complement
	attr_accessor :billing_address_district
	attr_accessor :billing_address_city
	attr_accessor :billing_address_state
	attr_accessor :billing_address_zipcode

	# Validations
	validates :hash, presence: true
	validates :installment_count, presence: true
	validates :holder_fullname, presence: true
	validates :holder_cpf, presence: true
	validates :holder_phone_area_code, presence: true
	validates :holder_phone_number, presence: true
	validates :billing_address_street, presence: true
	validates :billing_address_number, presence: true
	validates :billing_address_district, presence: true
	validates :billing_address_city, presence: true
	validates :billing_address_state, presence: true
	validates :billing_address_zipcode, presence: true
end

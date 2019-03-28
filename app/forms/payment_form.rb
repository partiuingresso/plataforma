class PaymentForm
	include ActiveModel::Model

	attr_accessor(
		:installment_count,
		:hash, # Credit Card Hash generated with moip.js
		:holder_fullname,
		:holder_birthdate,
		:holder_document,
		:holder_phone_area_code,
		:holder_phone_number,
		:holder_phone,
		:billing_address # The billing address form
	)

	validates :installment_count, presence: true
	validates :hash, presence: true
	validates :holder_fullname, presence: true
	validates :holder_birthdate, presence: true
	validates :holder_document, presence: true
	validates :holder_phone_area_code, presence: true
	validates :holder_phone_number, presence: true
	validate :billing_address_valid

	def initialize(attributes={})
		if attributes.present?
			self.installment_count = attributes[:installment_count]
			self.hash = attributes["hash"]
			self.holder_fullname = attributes["holder_fullname"]
			year = attributes['holder_birthdate(1i)']
			month = attributes['holder_birthdate(2i)']
			day = attributes['holder_birthdate(3i)']
			self.holder_birthdate = [year, month, day]
			self.holder_document = attributes["holder_document"]
			self.holder_phone = attributes["holder_phone"]
			self.billing_address_attributes = attributes["billing_address_attributes"]
		end
		@billing_address ||= AddressForm.new
	end

	def installment_count=(installment_count)
		@installment_count = installment_count.to_i
	end

	def holder_birthdate=(birthdate)
		@holder_birthdate = Date.new(birthdate[0].to_i, birthdate[1].to_i, birthdate[2].to_i)
	end

	def holder_document=(holder_document)
		@holder_document = holder_document.gsub(/[\.\-]/, "")
	end

    def holder_phone=(phone)
    	@holder_phone = phone
        @holder_phone_area_code = /\(\d\d\)/.match(phone).to_s.gsub(/[()]/, '')
        @holder_phone_number = /(?:\d\s*)?[0-9]{4}-?[0-9]{4}/.match(phone).to_s.gsub(/\s+/, '').sub(/-/, '')
    end

	def billing_address_attributes=(billing_address_params)
		@billing_address = AddressForm.new(billing_address_params)
	end

	private

		def billing_address_valid
			if billing_address.invalid?
				billing_address.errors.full_messages.each do |full_message|
					self.errors.add(:base, full_message)
				end
			end
		end
end

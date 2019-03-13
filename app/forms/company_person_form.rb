class CompanyPersonForm
	include ActiveModel::Model

	attr_accessor(
		:name,
		:first_name,
		:last_name,
		:email,
		:document_number,
		:birthdate,
		:phone,
		:phone_area_code,
		:phone_number,
		:address
	)


	validates :name, presence: true
	validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
	validates :document_number, presence: true
	validates :birthdate, presence: true
    validates :phone, format: /\A\(\d\d\)\s*(?:\d\s*)?[0-9]{4}-?[0-9]{4}\z/
    validate :address_valid

	def initialize(attributes={})
		if attributes.present?
			self.name = attributes[:name]
			self.email = attributes[:email]
			self.document_number = attributes[:document_number]
			self.phone = attributes[:phone]
			year = attributes['birthdate(1i)']
			month = attributes['birthdate(2i)']
			day = attributes['birthdate(3i)']
			self.birthdate = [year, month, day]
			self.address = attributes[:address]
		end
		@address ||= AddressForm.new
	end

	def name=(name)
		@name = NameOfPerson::PersonName.full(name)
		@first_name = @name.first
		@last_name = @name.last
	end

	def birthdate=(birthdate)
		@birthdate = Date.new(birthdate[0].to_i, birthdate[1].to_i, birthdate[2].to_i)
	end

    def phone=(phone)
    	@phone = phone
        @phone_area_code = /\(\d\d\)/.match(phone).to_s.gsub(/[()]/, '')
        @phone_number = /(?:\d\s*)?[0-9]{4}-?[0-9]{4}/.match(phone).to_s.gsub(/\s+/, '').sub(/-/, '')
    end

	def address=(address_params)
		@address = AddressForm.new(address_params)
	end

	private

		def address_valid
			if address.invalid?
				address.errors.full_messages.each do |full_message|
					self.errors.add(:base, full_message)
				end
			end
		end
end
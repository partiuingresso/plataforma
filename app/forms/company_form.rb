class CompanyForm
	include ActiveModel::Model

	attr_accessor(
		:success, # Indicates wheter the save was successful
		:name,
		:business_name,
		:document_number,
		:email,
		:phone,
		:phone_number,
		:phone_area_code,
		:person, # The company person form
		:address # The company address form
	)

    validates :name, presence: true
    validates :business_name, presence: true
    validates :document_number, presence: true
    validates :phone_area_code, presence: true
    validates :phone, format: /\A\(\d\d\)\s*(?:\d\s*)?[0-9]{4}-?[0-9]{4}\z/
    validate :address_valid

	def initialize(attributes={})
		super
		@person ||= CompanyPersonForm.new
		@address ||= AddressForm.new
	end

	def save
		begin
			if valid?
				@company = Company.new({
					name: name,
					business_name: business_name,
					document_number: document_number,
					email: email,
					phone_area_code: phone_area_code,
					phone_number: phone_number,
					address_attributes: address.serializable_hash
				})
			    account = Wirecard::create_account person, @company
			    @company.moip_id = account.id
			    @company.moip_access_token = account.access_token
			    @company.save!
				@success = true
			else
				@success = false
			end
		rescue => e
			self.errors.add(:base, e.message)
			@success = false
		end
	end

    def phone=(phone)
    	@phone = phone
        @phone_area_code = /\(\d\d\)/.match(phone).to_s.gsub(/[()]/, '')
        @phone_number = /(?:\d\s*)?[0-9]{4}-?[0-9]{4}/.match(phone).to_s.gsub(/\s+/, '').sub(/-/, '')
    end

	def person_attributes=(company_person_params)
		@person = CompanyPersonForm.new(company_person_params)
	end

	def address_attributes=(address_attributes_params)
		@address = AddressForm.new(address_attributes_params)
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
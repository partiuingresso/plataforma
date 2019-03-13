class AddressForm
	include ActiveModel::Model
	include ActiveModel::Serialization

	attr_accessor(
		:name,
		:zipcode,
		:address,
		:number,
		:complement,
		:district,
		:city,
		:state
	)

	validates :name, length: { maximum: 150 }, allow_blank: true
	validates :address, presence: true, length: { maximum: 150 }
	validates :number, presence: true
	validates :complement, length: { maximum: 50 }, allow_blank: true
	validates :district, presence: true, length: { maximum: 100 }
	validates :city, presence: true, length: { maximum: 100 }
	validates :state, presence: true, length: { maximum: 100 }
	validates :zipcode, presence: true, format: { with: /\A\d{5}-\d{3}\Z/,
		message: "only allows cep format" }

	def attributes
		{
			'name' => nil,
			'zipcode' => nil,
			'address' => nil,
			'number' => nil,
			'complement' => nil,
			'district' => nil,
			'city' => nil,
			'state' => nil
		}
	end
end
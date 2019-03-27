class TicketTokenForm
	include ActiveModel::Model
	include ActiveModel::Serialization

	attr_accessor(
		:owner_name,
		:owner_email
	)

	validates :owner_name, presence: true
	validates :owner_email, format: { with: URI::MailTo::EMAIL_REGEXP }

	def attributes
		{
			'owner_name' => nil,
			'owner_email' => nil
		}
	end
end
class OrderItemForm
	include ActiveModel::Model
	include ActiveModel::Serialization

	attr_accessor(
		:offer_id,
		:quantity,
		:ticket_tokens
	)

	validates :offer_id, presence: true
	validates :quantity, presence: true
	validate :ticket_tokens_valid

	def attributes
		{
			"offer_id" => nil,
			"quantity" => nil,
			"ticket_tokens_attributes" => nil
		}
	end

	def initialize(attributes={})
		super
		@ticket_tokens ||= []
		if @ticket_tokens.empty? && @offer_id.present? && @quantity.present?
			@quantity.times do
				@ticket_tokens.push(TicketTokenForm.new)
			end
		end
	end

	def ticket_tokens_attributes=(ticket_tokens_params)
		@ticket_tokens ||= []
		ticket_tokens_params.each do |i, ticket_token_params|
			@ticket_tokens.push(TicketTokenForm.new(ticket_token_params))
		end
	end

	def ticket_tokens_attributes
		build_ticket_tokens_attributes
	end

	def quantity=(quantity)
		@quantity = quantity.to_i
	end

	def offer_name
		offer = Offer.find(self.offer_id)
		unless offer.nil?
			offer.name
		end
	end

	private

		def build_ticket_tokens_attributes
			ticket_tokens.map do |ticket_token|
				ticket_token.serializable_hash
			end
		end

		def ticket_tokens_valid
			if ticket_tokens.empty?
				self.errors.add(:base, "Ticket tokens can't be empty.")
			else
				ticket_tokens.each do |ticket_token|
					next if ticket_token.valid?
					ticket_token.errors.full_messages.each do |full_message|
						self.errors.add(:base, full_message)
					end
				end
			end
		end


end
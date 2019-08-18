class ProducerAdmin::OfferAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :producer_admin
		can [:read, :create, :update], Offer, event: { company_id: user.company_id }
	end
end
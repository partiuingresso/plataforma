class ProducerAdmin::OfferAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :producer_admin
		can [:read, :create, :update, :destroy], Offer, event: { seller_id: user.seller_id }
	end
end
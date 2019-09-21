class ProducerAdmin::EventAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :producer_admin
		can :manage, Event, seller_id: user.seller.id
	end
end
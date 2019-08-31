class Producer::EventAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :producer
		can :read, Event, seller_id: user.seller_id
	end
end
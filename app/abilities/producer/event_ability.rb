class Producer::EventAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :producer
		can :read, Event, company_id: user.company_id
	end
end
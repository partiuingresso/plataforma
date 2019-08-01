class Producer::ValidationAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :producer
	    can :create, Validation
	end
end
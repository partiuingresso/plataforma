class TicketTokenAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :user
	    can :read, TicketToken
	end
end
class Producer::CheckInAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :producer
		can :show, :check_in
	end
end
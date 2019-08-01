class ProducerAdmin::DashboardAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :producer_admin
		can :show, :dashboard
	end
end

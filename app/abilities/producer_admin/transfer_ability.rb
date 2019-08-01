class ProducerAdmin::TransferAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :producer_admin
		can :create, Transfer
	end
end
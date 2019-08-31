class ProducerAdmin::FinanceAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :producer_admin
		can [:read, :create, :update], Finance, seller_id: user.seller_id
	end
end
class ProducerAdmin::CompanyAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :producer_admin
		can [:read, :update, :remove_staff], Company, id: user.company_id
	end
end

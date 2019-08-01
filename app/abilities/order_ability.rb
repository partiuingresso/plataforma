class OrderAbility
	include CanCan::Ability

	def initialize(user)
	    can [:create, :success], Order
	    return unless user.role? :user
		can :read, Order, user_id: user.id
	end
end

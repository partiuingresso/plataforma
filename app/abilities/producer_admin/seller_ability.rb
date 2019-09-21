class ProducerAdmin::SellerAbility
	include CanCan::Ability

	def initialize(user)
		return unless user.role? :producer_admin
		can [:read, :create, :update, :remove_staff], Seller, id: user.seller.id
	end
end

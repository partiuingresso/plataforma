class Admin::FinancesController < ApplicationController
	load_resource :seller
	load_and_authorize_resource :finance, through: :seller, singleton: true

	def new
		if @seller.reload.finance.present?
			redirect_to edit_admin_seller_finance_path and return
		end
		@finance.build_bank_account
	end

	def edit
		@seller = Seller.find(params[:seller_id])
		@finance = @seller.finance
		render :new
	end

	private
	
		def current_ability
			@current_ability ||= AdminAbility.new(current_user)
		end
end

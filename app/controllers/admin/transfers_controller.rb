class Admin::TransfersController < ApplicationController
	load_and_authorize_resource

	def create
		@seller = @transfer.seller
		unless @seller.verified?
			msg = "Esta conta não foi verificada."
			redirect_to admin_seller_path(@seller), alert: msg and return
		end

		@transfer.bank_account = @seller.bank_account
		if @transfer.save
			moip_transfer = Wirecard::create_transfer @transfer.reload
			if moip_transfer.respond_to?(:id) && moip_transfer.id.present?
				@transfer.update(fee_cents: moip_transfer.fee)
				redirect_to admin_seller_path(@seller), notice: "Transferência solicitada com sucesso."
			else
				@transfer.destroy
				render plain: moip_transfer.inspect
			end
		else
			render plain: @transfer.errors.messages
		end
	end

	private

		def transfer_params
			params.require(:transfer).permit(:seller_id, :amount)
		end

		def current_ability
			@current_ability ||= AdminAbility.new(current_user)
		end
end

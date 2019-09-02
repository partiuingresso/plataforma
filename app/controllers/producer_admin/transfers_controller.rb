class ProducerAdmin::TransfersController < ApplicationController
	load_and_authorize_resource

	def create
		@transfer.bank_account = @transfer.seller.bank_account
		if @transfer.save
			moip_transfer = Wirecard::create_transfer @transfer.reload
			if moip_transfer.respond_to?(:id) && moip_transfer.id.present?
				@transfer.update(fee_cents: moip_transfer.fee)
				redirect_to seller_path(@transfer.seller), notice: "Transferência solicitada com sucesso."
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
			@current_ability ||= ProducerAdmin::TransferAbility.new(current_user)
		end
end

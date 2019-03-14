class TransfersController < ApplicationController
	load_and_authorize_resource

	def create
		@transfer.bank_account = @transfer.company.bank_account
		if @transfer.save
			moip_transfer = Wirecard::create_transfer @transfer.reload
			if moip_transfer.respond_to?(:id) && moip_transfer.id.present?
				@transfer.update(fee_cents: moip_transfer.fee)
				render plain: "Transferência solicitada com sucesso."
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
			params.require(:transfer).permit(:company_id, :amount)
		end

end

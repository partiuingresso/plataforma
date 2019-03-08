class TransfersController < ApplicationController
	load_and_authorize_resource

	def create
		@transfer.bank_account = @transfer.company.bank_account
		if @transfer.save
			render plain: "Transferência solicitada com sucesso."
		else
			render plain: @transfer.errors.messages
		end
	end

	private

		def transfer_params
			params.require(:transfer).permit(:company_id, :amount)
		end

end

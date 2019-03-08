class TransfersController < ApplicationController
	load_and_authorize_resource

	def create
		@transfer.bank_account = @transfer.company.bank_account
		unless @transfer.valid?
			redirect_to @transfer.company, alert: "Ops... algo deu errado! Tente novamente.(1)" and return
		end

		moip_transfer = Wirecard::create_transfer @transfer
		unless moip_transfer.respond_to?(:id) && moip_transfer.id.present?
			# redirect_to @transfer.company, alert: "Ops... algo deu errado! Tente novamente.(2)" and return
			render plain: moip_transfer.inspect and return
		end

		@transfer.fee = moip_transfer.fee
		@transfer.amount_cents = moip_transfer.amount
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

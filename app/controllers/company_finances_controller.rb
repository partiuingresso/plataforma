class CompanyFinancesController < ApplicationController
	load_and_authorize_resource

	def new
	end

	def create
		@company_finance.moip_id = "1"
		account = Wirecard::create_account current_user, @company_finance
		render plain: account.inspect
	end

	def edit
	end

	def update
		if @company_finance.save
			render plain: "OK"
		else
			render plain: @company_finance.errors.messages
		end
	end

	private
	def company_finance_params
		params.require(:company_finance).permit(:legal_name, :document_type, 
			:document_number, :birth_date, :phone, :bank_code, :account_type, :agencia, :agencia_dv, :conta, :conta_dv,
			:address, :number, :complement, :district, :city, :state, :zipcode)
	end
end

class CompanyFinancesController < ApplicationController
	load_and_authorize_resource

	def new
	end

	def create
		account = Wirecard::create_account
		if account.respond_to?(:id) && account.id.present?
			@company_finance.moip_id = account.id
			@company_finance.access_token = account.access_token
			if @company_finance.save
				bank_account = Wirecard::create_bank_account @company_finance
				if bank_account.respond_to?(:id) && bank_account.id.present?
					flash[:notice] = "Conta bancária criada com sucesso."
					redirect_to edit_company_finance_path(@company_finance)
				else
					flash[:danger] = "Erro ao registrar conta bancária moip."
					redirect_back(fallback_location: new_company_finance_path)
				end
			else
				flash[:danger] = "Erro ao salvar conta bancária."
				redirect_back(fallback_location: new_company_finance_path)
			end
		else
			flash[:danger] = "Erro ao criar conta moip."
			redirect_back(fallback_location: new_company_finance_path)
		end
	end

	def edit
		render :new
	end

	def update
		@company_finance.assign_attributes(company_finance_params)
		if @company_finance.valid?
			bank_account = Wirecard::bank_accounts(@company_finance).first
			if Wirecard::update_bank_account @company_finance.reload, bank_account.id
				@company_finance.save
				flash[:notice] = "Conta bancária atualizada com sucesso."
				redirect_to edit_company_finance_path(@company_finance)
			else
				render plain: "Erro ao atualizar a conta bancária. Revise os campos enviados."
			end
		else
			flash[:danger] = "Conta bancária inválida."
			redirect_back(fallback_location: edit_company_finance_path(@company_finance))
		end
	end

	private
	def company_finance_params
		params.require(:company_finance).permit(:legal_name, :document_type, :document_number, :bank_code,
												:account_type, :agency_number, :agency_check_number,
												:account_number, :account_check_number)
	end
end

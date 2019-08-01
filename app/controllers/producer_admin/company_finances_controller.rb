class ProducerAdmin::CompanyFinancesController < ApplicationController
	load_and_authorize_resource

	def new
		@company_finance.build_bank_account
	end

	def create
		bank_account = Wirecard::create_bank_account @company_finance.company
		unless bank_account.respond_to?(:id) && bank_account.id.present?
			redirect_to new_company_finance_path, alert: "Ops... algo deu errado! Tente novamente." and return
		end
		@company_finance.bank_account.moip_id = bank_account.id

		if @company_finance.save
			redirect_to edit_company_finance_path(@company_finance), notice: "Conta bancária criada com sucesso."
		else
			Wirecard::delete_bank_account @company_finance.company
			redirect_to new_company_finance_path, alert: "Ops... algo deu errado! Tente novamente."
		end
	end

	def edit
		render :new
	end

	def update
		@company_finance.assign_attributes(company_finance_params)
		if @company_finance.bank_account.transfers.exists?
			bank_account_attributes = @company_finance.bank_account.attributes
			bank_account_attributes[:id] = nil
			@company_finance.build_bank_account(bank_account_attributes)
			moip_bank_account = Wirecard::create_bank_account @company_finance.company
			unless moip_bank_account.respond_to?(:id) && moip_bank_account.id.present?
				redirect_to new_company_finance_path, alert: "Ops... algo deu errado! Tente novamente." and return
			end
			@company_finance.bank_account.moip_id = moip_bank_account.id
			if @company_finance.save
				redirect_to edit_company_finance_path(@company_finance), notice: "Conta bancária atualizada com sucesso."
			else
				redirect_to edit_company_finance_path(@company_finance), alert: "Ops... algo deu errado! Tente novamente."
			end
		else
			if @company_finance.valid? && Wirecard::update_bank_account(@company_finance.company) && @company_finance.save
				redirect_to edit_company_finance_path(@company_finance), notice: "Conta bancária atualizada com sucesso."
			else
				redirect_to edit_company_finance_path(@company_finance), alert: "Ops... algo deu errado! Tente novamente."
			end
		end

	end

	private

		def company_finance_params
			params.require(:company_finance).permit(bank_account_attributes: [:id, :legal_name, :document_type,
													:document_number, :bank_code, :account_type, :agency_number,
													:agency_check_number, :account_number, :account_check_number])
		end

		def current_ability
			@current_ability ||= ProducerAdmin::CompanyFinanceAbility.new(current_user)
		end
end

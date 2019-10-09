class Admin::FinancesController < ApplicationController
	load_resource :seller
	load_and_authorize_resource :finance, through: :seller, singleton: true

	def new
		if @seller.reload.finance.present?
			redirect_to edit_admin_seller_finance_path(@seller) and return
		end
		@finance.build_bank_account
	end

	def create
		bank_account = Wirecard::create_bank_account @finance.seller
		unless bank_account.respond_to?(:id) && bank_account.id.present?
			redirect_to new_admin_seller_finance_path(@seller), alert: "Ops... algo deu errado! Tente novamente." and return
		end
		@finance.bank_account.moip_id = bank_account.id

		if @finance.save
			redirect_to edit_admin_seller_finance_path(@seller), notice: "Conta bancária criada com sucesso."
		else
			Wirecard::delete_bank_account @finance.seller
			redirect_to new_admin_seller_finance_path(@seller), alert: "Ops... algo deu errado! Tente novamente."
		end
	end

	def edit
		@seller = Seller.find(params[:seller_id])
		@finance = @seller.finance
		render :new
	end

	def update
		@finance.assign_attributes(finance_params)
		if @finance.bank_account.transfers.exists?
			bank_account_attributes = @finance.bank_account.attributes
			bank_account_attributes[:id] = nil
			@finance.build_bank_account(bank_account_attributes)
			moip_bank_account = Wirecard::create_bank_account @finance.seller
			unless moip_bank_account.respond_to?(:id) && moip_bank_account.id.present?
				redirect_to new_admin_seller_finance_path(@seller), alert: "Ops... algo deu errado! Tente novamente." and return
			end
			@finance.bank_account.moip_id = moip_bank_account.id
			if @finance.save
				redirect_to edit_admin_seller_finance_path(@seller), notice: "Conta bancária atualizada com sucesso."
			else
				redirect_to edit_admin_seller_finance_path(@seller), alert: "Ops... algo deu errado! Tente novamente."
			end
		else
			if @finance.valid? && Wirecard::update_bank_account(@finance.seller) && @finance.save
				redirect_to edit_admin_seller_finance_path(@seller), notice: "Conta bancária atualizada com sucesso."
			else
				redirect_to edit_admin_seller_finance_path(@seller), alert: "Ops... algo deu errado! Tente novamente."
			end
		end

	end

	private

		def finance_params
			params.require(:finance).permit(bank_account_attributes: [:id, :legal_name, :document_type,
													:document_number, :bank_code, :account_type, :agency_number,
													:agency_check_number, :account_number, :account_check_number])
		end
	
		def current_ability
			@current_ability ||= AdminAbility.new(current_user)
		end
end

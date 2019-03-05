class CompanyFinancesAddBankAccountId < ActiveRecord::Migration[5.2]
  def change
  	add_column :company_finances, :bank_account_id, :string
  end
end

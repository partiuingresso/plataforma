class CompanyFinancesChangeColumnName < ActiveRecord::Migration[5.2]
  def change
  	rename_column :company_finances, :type, :account_type
  end
end

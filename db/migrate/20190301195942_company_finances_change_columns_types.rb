class CompanyFinancesChangeColumnsTypes < ActiveRecord::Migration[5.2]
  def up
  	change_column :company_finances, :bank_code, :string
  	change_column :company_finances, :agencia, :string
  	change_column :company_finances, :agencia_dv, :string
  	change_column :company_finances, :conta, :string
  	change_column :company_finances, :conta_dv, :string

  	rename_column :company_finances, :agencia, :agency_number
  	rename_column :company_finances, :agencia_dv, :agency_check_number
  	rename_column :company_finances, :conta, :account_number
  	rename_column :company_finances, :conta_dv, :account_check_number

  	change_column_null :company_finances, :access_token, false
  end

  def down
  	rename_column :company_finances, :agency_number, :agencia
  	rename_column :company_finances, :agency_check_number, :agencia_dv
  	rename_column :company_finances, :account_number, :conta
  	rename_column :company_finances, :account_check_number, :conta_dv

  	change_column :company_finances, :bank_code, "integer USING bank_code::integer" 
  	change_column :company_finances, :agencia, "integer USING agencia::integer"
  	change_column :company_finances, :agencia_dv, "integer USING agencia_dv::integer"
  	change_column :company_finances, :conta, "integer USING conta::integer"
  	change_column :company_finances, :conta_dv, "integer USING conta_dv::integer"

  	change_column_null :company_finances, :access_token, true
  end
end

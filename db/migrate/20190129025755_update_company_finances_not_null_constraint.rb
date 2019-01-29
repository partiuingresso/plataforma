class UpdateCompanyFinancesNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :company_finances, :bank_code, false
  	change_column_null :company_finances, :agencia, false
  	change_column_null :company_finances, :agencia_dv, false
  	change_column_null :company_finances, :conta, false
  	change_column_null :company_finances, :type, false
  	change_column_null :company_finances, :conta_dv, false
  	change_column_null :company_finances, :document_number, false
  	change_column_null :company_finances, :legal_name, false
  end

  def down
  	change_column_null :company_finances, :bank_code, true
  	change_column_null :company_finances, :agencia, true
  	change_column_null :company_finances, :agencia_dv, true
  	change_column_null :company_finances, :conta, true
  	change_column_null :company_finances, :type, true
  	change_column_null :company_finances, :conta_dv, true
  	change_column_null :company_finances, :document_number, true
  	change_column_null :company_finances, :legal_name, true
  end

end

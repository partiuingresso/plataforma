class CompanyFinancesChangeNullConstraint < ActiveRecord::Migration[5.2]
  def change
  	change_column_null :company_finances, :agencia_dv, true
  end
end

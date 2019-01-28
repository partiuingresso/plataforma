class UpdateCompaniesNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :companies, :name, false
  	change_column_null :companies, :company_finance_id, false
  end

  def down
  	change_column_null :companies, :name, true
  	change_column_null :companies, :company_finance_id, true
  end

end

class CompanyFinancesAddAccessToken < ActiveRecord::Migration[5.2]
  def change
  	add_column :company_finances, :access_token, :string
  end
end

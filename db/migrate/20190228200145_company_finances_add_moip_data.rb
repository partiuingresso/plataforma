class CompanyFinancesAddMoipData < ActiveRecord::Migration[5.2]
  def change
  	add_column :company_finances, :moip_id, :string, null: false
  	add_column :company_finances, :document_type, :string, null: false
  end
end

class MoveMoipIdToCompany < ActiveRecord::Migration[5.2]
  def change
  	remove_column :company_finances, :moip_id, :string, null: false
  	remove_column :company_finances, :access_token, :string, null: false
  	add_column :companies, :moip_id, :string, null: false
  	add_column :companies, :moip_access_token, :string, null: false
  end
end

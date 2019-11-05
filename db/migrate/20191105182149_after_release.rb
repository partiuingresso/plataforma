class AfterRelease < ActiveRecord::Migration[5.2]
  def change
  	# Sellers
  	add_timestamps :sellers, null: true

  	# Transfers
  	remove_column :transfers, :company_id, :bigint
  	change_column_null :transfers, :seller_id, false

  	# Users
  	remove_column :users, :company_id, :bigint

  	# Events
  	remove_column :events, :company_id, :bigint
  	change_column_null :events, :seller_id, false

  	# Finances
  	change_column_null :finances, :seller_id, false

  	# Companies
  	change_column_null :companies, :seller_id, false
  	change_column_null :companies, :document_number, false
  	change_column_null :companies, :business_name, false
  	change_column_null :companies, :name, false
  	change_column_null :companies, :address_id, false
  	remove_column :companies, :moip_id, :string
  	remove_column :companies, :moip_access_token, :string
  	remove_column :companies, :email, :string
  	remove_column :companies, :phone_number, :integer
  	remove_column :companies, :phone_area_code, :integer
  end
end

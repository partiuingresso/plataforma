class RenameCompanyToSeller < ActiveRecord::Migration[5.2]
  def up
  	rename_table :companies, :sellers
  	rename_table :company_finances, :finances

  	rename_column :users, :company_id, :seller_id
  	rename_column :finances, :company_id, :seller_id
  	rename_column :transfers, :company_id, :seller_id
  	rename_column :events, :company_id, :seller_id
  end

  def down
  	rename_table :sellers, :companies
  	rename_table :finances, :company_finances

  	rename_column :users, :seller_id, :company_id
  	rename_column :company_finances, :seller_id, :company_id
  	rename_column :transfers, :seller_id, :company_id
  	rename_column :events, :seller_id, :company_id
  end
end

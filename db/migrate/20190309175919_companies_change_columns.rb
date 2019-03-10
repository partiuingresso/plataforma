class CompaniesChangeColumns < ActiveRecord::Migration[5.2]
  def change
    change_column_null :addresses, :name, true
  	add_reference :users, :address, foreign_key: true
  	add_column :users, :phone_area_code, :integer
  	add_column :users, :phone_number, :integer

  	add_reference :companies, :address, foreign_key: true, null: false
  	add_column :companies, :business_name, :string, null: false
  	add_column :companies, :document_type, :string, null: false
  	add_column :companies, :document_number, :string, null: false
  	add_column :companies, :phone_area_code, :integer, null: false
  	add_column :companies, :phone_number, :integer, null: false
  end
end

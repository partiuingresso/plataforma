class UpdateCompanyFinances < ActiveRecord::Migration[5.2]
  def up
    remove_column :company_finances, :bank_account_id
    remove_column :company_finances, :legal_name
    remove_column :company_finances, :document_type
    remove_column :company_finances, :document_number
    remove_column :company_finances, :bank_code
    remove_column :company_finances, :account_type
    remove_column :company_finances, :agency_number
    remove_column :company_finances, :agency_check_number
    remove_column :company_finances, :account_number
    remove_column :company_finances, :account_check_number

    add_reference :company_finances, :bank_account, null: false, foreign_key: true, index: { unique: true }
  end
  def down
    remove_reference :company_finances, :bank_account

    add_column :company_finances, :bank_account_id, :string
    add_column :company_finances, :legal_name, :string, null: false
    add_column :company_finances, :document_type, :string, null: false
    add_column :company_finances, :document_number, :string, null: false
    add_column :company_finances, :bank_code, :string, null: false
    add_column :company_finances, :account_type, :string, null: false
    add_column :company_finances, :agency_number, :string, null: false
    add_column :company_finances, :agency_check_number, :string
    add_column :company_finances, :account_number, :string, null: false
    add_column :company_finances, :account_check_number, :string, null: false
  end
end

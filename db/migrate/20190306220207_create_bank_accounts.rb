class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
		t.string "moip_id", null: false
		t.string "legal_name", null: false
		t.string "document_type", null: false
		t.string "document_number", null: false
		t.string "bank_code", null: false
		t.string "agency_number", null: false
		t.string "agency_check_number"
		t.string "account_number", null: false
		t.string "account_type", null: false
		t.string "account_check_number", null: false
		t.timestamps
    end
  end
end

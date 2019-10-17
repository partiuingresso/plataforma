class ReleaseMigration < ActiveRecord::Migration[5.2]
  def change
		create_table :sellers do |t|
			t.string :moip_id, null: false
			t.string :moip_access_token, null: false
			t.string :email
			t.integer :phone_area_code, null: false
			t.integer :phone_number, null: false
			t.boolean :verified, null: false, default: false
		end

		remove_foreign_key :transfers, :companies
		change_column_null :transfers, :company_id, true
		add_reference :transfers, :seller, foreign_key: true

		remove_foreign_key :users, :companies
		change_column_null :users, :company_id, true

		remove_foreign_key :events, :companies
		change_column_null :events, :company_id, true
		add_reference :events, :seller, foreign_key: true

		remove_foreign_key :company_finances, :companies
		rename_column :company_finances, :company_id, :id
		add_reference :company_finances, :seller, foreign_key: true, index: { unique: true }

		add_reference :companies, :seller, foreign_key: true, index: { unique: true }
		change_column_null :companies, :moip_id, true
		change_column_null :companies, :moip_access_token, true
		change_column_null :companies, :phone_area_code, true
		change_column_null :companies, :phone_number, true
		change_column_null :companies, :email, true

		rename_table :company_finances, :finances

		add_column :users, :actor_id, :bigint
  	add_column :users, :actor_type, :string
  	add_index :users, [:actor_type, :actor_id], unique: true

		create_table :event_staff do |t|
    	t.references :event, foreign_key: true, null: false
      t.timestamps
    end
    create_table :seller_staff do |t|
    	t.references :seller, foreign_key: true, null: false
      t.timestamps
    end
  end
end

class UpdateOneToOneRelations < ActiveRecord::Migration[5.2]
	def up
		# companies and company_finances
		remove_reference :companies, :company_finance
		add_reference :company_finances, :company, null: false
		remove_column :company_finances, :id

		execute <<-SQL
			ALTER TABLE company_finances
				ADD PRIMARY KEY (company_id);
		SQL

		# validations and ticket_tokens
		remove_reference :ticket_tokens, :validation
		add_reference :validations, :ticket_token, null: false
		remove_column :validations, :id

		execute <<-SQL
			ALTER TABLE validations
				ADD PRIMARY KEY (ticket_token_id);
		SQL

		# orders and payment
		remove_reference :orders, :payment
		add_reference :payments, :order, null: false
		remove_column :payments, :id

		execute <<-SQL
			ALTER TABLE payments
				ADD PRIMARY KEY (order_id);
		SQL
	end
	def down
		# companies and company_finances
		add_reference :companies, :company_finance, null: false
		remove_column :company_finances, :company_id
		add_column :company_finances, :id, :primary_key

		execute <<-SQL
			ALTER TABLE company_finances
				DROP CONSTRAINT company_finances_pkey;

			ALTER TABLE company_finances
				ADD PRIMARY KEY (id);
		SQL

		# validations and ticket_tokens
		add_reference :ticket_tokens, :validation
		remove_column :validations, :ticket_token_id
		add_column :validations, :id, :primary_key

		execute <<-SQL
			ALTER TABLE validations
				DROP CONSTRAINT validations_pkey;

			ALTER TABLE validations
				ADD PRIMARY KEY (id);
		SQL
	
		# orders and payment
		add_reference :orders, :payment, null: false
		remove_column :payments, :order_id
		add_column :payments, :id, :primary_key

		execute <<-SQL
			ALTER TABLE payments
				DROP CONSTRAINT payments_pkey;

			ALTER TABLE payments
				ADD PRIMARY KEY (id);
		SQL
	end
end

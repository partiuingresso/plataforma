class UpdateColumnTypes < ActiveRecord::Migration[5.2]

	def up
		# Orders table
		change_column :orders, :number, :integer, using: 'number::integer'

		# Company_finances table
		change_column :company_finances, :bank_code, :integer, using: 'bank_code::integer'
		change_column :company_finances, :agencia, :integer, using: 'agencia::integer'
		change_column :company_finances, :agencia_dv, :integer, using: 'agencia_dv::integer'
		change_column :company_finances, :conta, :integer, using: 'conta::integer'
		change_column :company_finances, :conta_dv, :integer, using: 'conta_dv::integer'

		# Event_venues table
		change_column :event_venues, :number, :integer, using: 'number::integer'
	end

	def down
		# Orders table
		change_column :orders, :number, :string

		# Company_finances table
		change_column :company_finances, :bank_code, :string
		change_column :company_finances, :agencia, :string
		change_column :company_finances, :agencia_dv, :string
		change_column :company_finances, :conta, :string
		change_column :company_finances, :conta_dv, :string

		# Event_venues table
		change_column :event_venues, :number, :string
	end

end

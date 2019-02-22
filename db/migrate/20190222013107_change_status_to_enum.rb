class ChangeStatusToEnum < ActiveRecord::Migration[5.2]
	def up
		remove_reference :orders, :order_status
		remove_reference :ticket_tokens, :ticket_status

		drop_table :order_statuses
		drop_table :ticket_statuses

		execute <<-SQL
			CREATE TYPE order_status AS ENUM ('pending', 'approved', 'denied', 'refunded');
			CREATE TYPE ticket_status AS ENUM ('pending', 'ready', 'authenticated', 'expired', 'cancelled');
		SQL

		add_column :orders, :status, :order_status, null: false, default: 'pending'
		add_column :ticket_tokens, :status, :ticket_status, null: false, default: 'pending'
		add_index :orders, :status
		add_index :ticket_tokens, :status
	end
	def down
		remove_index :orders, :status
		remove_column :orders, :status
		remove_index :ticket_tokens, :status
		remove_column :ticket_tokens, :status

		execute <<-SQL
			DROP TYPE order_status;
			DROP TYPE ticket_status;
		SQL

		create_table "order_statuses", force: :cascade do |t|
			t.string "name", null: false
			t.datetime "created_at", null: false
			t.datetime "updated_at", null: false
		end
		create_table "ticket_statuses", force: :cascade do |t|
			t.string "name", null: false
			t.datetime "created_at", null: false
			t.datetime "updated_at", null: false
		end

		add_reference :orders, :order_status, null: false
	  	add_foreign_key :orders, :order_statuses
		add_reference :ticket_tokens, :ticket_status, null: false
	  	add_foreign_key :ticket_tokens, :ticket_statuses
	end
end

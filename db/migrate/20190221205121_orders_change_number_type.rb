class OrdersChangeNumberType < ActiveRecord::Migration[5.2]
	def up
		remove_column :orders, :number
		add_column :orders, :number, :int8, null: false
		add_index :orders, :number, unique: true
	end
	def down
		remove_column :orders, :number
		add_column :orders, :number, :int4, null: false
		add_index :orders, :number, unique: true
	end
end

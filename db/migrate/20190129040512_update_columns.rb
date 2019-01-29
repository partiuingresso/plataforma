class UpdateColumns < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :gender, :string, null: false
  	rename_column :orders, :subotal, :subtotal
  	remove_column :order_items, :total_price, :decimal, precision: 10, scale: 2
  end
end

class ChangeMoneyColumns < ActiveRecord::Migration[5.2]
  def change
  	remove_column :offers, :price, :decimal, precision: 10, scale: 2, null: false
  	add_column :offers, :price_cents, :integer, null: false, default: 0
  	remove_column :orders, :subtotal, :decimal, precision: 10, scale: 2, null: false
  	add_column :orders, :subtotal_cents, :integer, null: false, default: 0
  end
end

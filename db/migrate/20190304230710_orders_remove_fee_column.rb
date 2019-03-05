class OrdersRemoveFeeColumn < ActiveRecord::Migration[5.2]
  def change
  	remove_column :orders, :fee, :decimal, presicion: 3, scale: 2, null: false
  end
end

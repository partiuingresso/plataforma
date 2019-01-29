class UpdateOrdersNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :orders, :number, false
  	change_column_null :orders, :subotal, false
  	change_column_null :orders, :fee, false
  	change_column_null :orders, :total, false
  	change_column_null :orders, :user_id, false
  	change_column_null :orders, :payment_id, false
  	change_column_null :orders, :order_status_id, false
  end

  def down
  	change_column_null :orders, :number, true
  	change_column_null :orders, :subotal, true
  	change_column_null :orders, :fee, true
  	change_column_null :orders, :total, true
  	change_column_null :orders, :user_id, true
  	change_column_null :orders, :payment_id, true
  	change_column_null :orders, :order_status_id, true
  end

end

class UpdateOrderItemsNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :order_items, :unit_price, false
  	change_column_null :order_items, :quantity, false
  	change_column_null :order_items, :total_price, false
  	change_column_null :order_items, :offer_id, false
  	change_column_null :order_items, :order_id, false
  end

  def down
    change_column_null :order_items, :unit_price, true
    change_column_null :order_items, :quantity, true
    change_column_null :order_items, :total_price, true
    change_column_null :order_items, :offer_id, true
    change_column_null :order_items, :order_id, true
  end

end

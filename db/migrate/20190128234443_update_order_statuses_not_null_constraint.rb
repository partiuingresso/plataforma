class UpdateOrderStatusesNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :order_statuses, :name, false
  end

  def down
  	change_column_null :order_statuses, :name, true
  end

end

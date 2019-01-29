class UpdatePaymentsNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :payments, :tid, false
  end

  def down
  	change_column_null :payments, :tid, true
  end

end

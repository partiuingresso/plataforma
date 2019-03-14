class TransfersChangeFeeNull < ActiveRecord::Migration[5.2]
  def change
  	change_column_null :transfers, :fee_cents, true
  end
end

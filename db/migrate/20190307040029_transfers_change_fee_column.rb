class TransfersChangeFeeColumn < ActiveRecord::Migration[5.2]
  def up
  	rename_column :transfers, :fee, :fee_cents
  	change_column :transfers, :fee_cents, :integer
  end
  def down
  	rename_column :transfers, :fee_cents, :fee
  	change_column :transfers, :fee, :decimal, precision: 3, scale: 2
  end
end

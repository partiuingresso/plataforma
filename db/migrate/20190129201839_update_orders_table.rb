class UpdateOrdersTable < ActiveRecord::Migration[5.2]
  def change
	remove_column :orders, :total, :decimal, precision: 10, scale: 2
  	reversible do |dir|
  		dir.up do
  			change_column :orders, :fee, :decimal, precision: 3, scale: 2
  		end
  		dir.down do	
  			change_column :orders, :fee, :decimal, precision: 10, scale: 2
  		end
  	end
  end
end

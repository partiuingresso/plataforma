class AddEventColumnToOrdersTable < ActiveRecord::Migration[5.2]
  def change
  	add_reference :orders, :event, null: false, foreign_key: true
  end
end

class AddEventColumnToOrdersTable < ActiveRecord::Migration[5.2]
  def change
  	add_reference :orders, :events, null: false, foreign_key: true
  end
end

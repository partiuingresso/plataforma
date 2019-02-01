class UpdateMinorAdjustments < ActiveRecord::Migration[5.2]
  def change
  	change_column_null :ticket_tokens, :order_item_id, false
  	remove_column :validations, :time, :datetime
  	add_index :order_items, [:order_id, :offer_id], unique: true
  	change_column_null :users, :age, true
  	change_column_null :users, :cpf, true
  	change_column_null :users, :gender, true
  end
end

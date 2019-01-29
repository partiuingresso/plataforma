class UpdateUniqueIndex < ActiveRecord::Migration[5.2]
  def change
  	add_index :orders, :number, unique: true
  	add_index :ticket_tokens, :code, unique: true
  end
end

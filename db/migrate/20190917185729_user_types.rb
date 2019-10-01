class UserTypes < ActiveRecord::Migration[5.2]
  def change
  	remove_reference :users, :seller, foreign_key: true
  	add_column :users, :actor_id, :bigint
  	add_column :users, :actor_type, :string
  	add_index :users, [:actor_type, :actor_id], unique: true

  	remove_reference :sellers, :owner, foreign_key: { to_table: :users }, index: { unique: true }
  end
end

class AddOwnerToSellers < ActiveRecord::Migration[5.2]
  def change
  	add_reference :sellers, :owner, foreign_key: { to_table: :users }, index: { unique: true }
  end
end

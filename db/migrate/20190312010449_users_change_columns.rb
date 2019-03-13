class UsersChangeColumns < ActiveRecord::Migration[5.2]
  def change
  	remove_reference :users, :address, foreign_key: true
  	remove_column :users, :phone_area_code, :integer
  	remove_column :users, :phone_number, :integer
  end
end

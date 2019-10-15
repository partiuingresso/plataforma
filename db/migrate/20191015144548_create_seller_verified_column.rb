class CreateSellerVerifiedColumn < ActiveRecord::Migration[5.2]
  def change
  	add_column :sellers, :verified, :boolean, null: false, default: true
  end
end

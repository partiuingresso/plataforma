class OfferRemoveColumnAvailableQuantity < ActiveRecord::Migration[5.2]
  def change
  	remove_column :offers, :available_quantity, :integer, null: false, default: 0
  end
end

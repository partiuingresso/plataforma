class UpdateForeignKeysConstraint < ActiveRecord::Migration[5.2]
  def change
  	add_foreign_key :company_finances, :companies
  	add_foreign_key :credit_cards, :users
  	add_foreign_key :events, :event_venues
  	add_foreign_key :events, :users
  	add_foreign_key :offers, :events
  	add_foreign_key :orders, :users
  	add_foreign_key :orders, :order_statuses
  	add_foreign_key :order_items, :orders
  	add_foreign_key :order_items, :offers
  	add_foreign_key :payments, :orders
  	add_foreign_key :ticket_tokens, :order_items
  	add_foreign_key :ticket_tokens, :ticket_statuses
  	add_foreign_key :users, :companies
  end
end

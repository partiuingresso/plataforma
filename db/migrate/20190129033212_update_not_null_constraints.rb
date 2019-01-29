class UpdateNotNullConstraints < ActiveRecord::Migration[5.2]

  def up
  	# Events table
  	change_column_null :events, :name, false
  	change_column_null :events, :start, false
  	change_column_null :events, :user_id, false

  	# Companies table
  	change_column_null :companies, :name, false
  	change_column_null :companies, :company_finance_id, false

  	# Offers table
  	change_column_null :offers, :name, false
  	change_column_null :offers, :price, false
  	change_column_null :offers, :event_id, false

  	# Orders table
  	change_column_null :orders, :number, false
  	change_column_null :orders, :subotal, false
  	change_column_null :orders, :fee, false
  	change_column_null :orders, :total, false
  	change_column_null :orders, :user_id, false
  	change_column_null :orders, :payment_id, false
  	change_column_null :orders, :order_status_id, false

  	# Order_statuses table
  	change_column_null :order_statuses, :name, false

  	# Order_items table
  	change_column_null :order_items, :unit_price, false
  	change_column_null :order_items, :quantity, false
  	change_column_null :order_items, :total_price, false
  	change_column_null :order_items, :offer_id, false
  	change_column_null :order_items, :order_id, false

  	# Tickets table
  	change_column_null :tickets, :offer_id, false

  	# Ticket_tokens table
  	change_column_null :ticket_tokens, :code, false
  	change_column_null :ticket_tokens, :owner_name, false
  	change_column_null :ticket_tokens, :owner_email, false
  	change_column_null :ticket_tokens, :ticket_id, false
  	change_column_null :ticket_tokens, :ticket_status_id, false

  	# Ticket_statuses table
  	change_column_null :ticket_statuses, :name, false

  	# Company_finances table
  	change_column_null :company_finances, :bank_code, false
  	change_column_null :company_finances, :agencia, false
  	change_column_null :company_finances, :agencia_dv, false
  	change_column_null :company_finances, :conta, false
  	change_column_null :company_finances, :type, false
  	change_column_null :company_finances, :conta_dv, false
  	change_column_null :company_finances, :document_number, false
  	change_column_null :company_finances, :legal_name, false

  	# Event_venues table
  	change_column_null :event_venues, :name, false
  	change_column_null :event_venues, :address, false
  	change_column_null :event_venues, :number, false
  	change_column_null :event_venues, :neighborhood, false
  	change_column_null :event_venues, :city, false
  	change_column_null :event_venues, :state, false
  	change_column_null :event_venues, :zipcode, false

  	# Payments table
  	change_column_null :payments, :tid, false

  	# Validations table
  	change_column_null :validations, :time, false
  	change_column_null :validations, :user_id, false

  	# Credit_cards table
  	change_column_null :credit_cards, :cardid, false
  	change_column_null :credit_cards, :user_id, false

  	# Users table
  	change_column_null :users, :first_name, false
  	change_column_null :users, :last_name, false
  	change_column_null :users, :age, false
  	change_column_null :users, :cpf, false
  	change_column_null :users, :role, false
  end

  def down 
  	# Events table
  	change_column_null :events, :name, true
  	change_column_null :events, :start, true
  	change_column_null :events, :user_id, true

  	# Companies table
  	change_column_null :companies, :name, true
  	change_column_null :companies, :company_finance_id, true

  	# Offers table
  	change_column_null :offers, :name, true
  	change_column_null :offers, :price, true
  	change_column_null :offers, :event_id, true

  	# Orders table
  	change_column_null :orders, :number, true
  	change_column_null :orders, :subotal, true
  	change_column_null :orders, :fee, true
  	change_column_null :orders, :total, true
  	change_column_null :orders, :user_id, true
  	change_column_null :orders, :payment_id, true
  	change_column_null :orders, :order_status_id, true

  	# Order_statuses table
  	change_column_null :order_statuses, :name, true

  	# Order_items table
    change_column_null :order_items, :unit_price, true
    change_column_null :order_items, :quantity, true
    change_column_null :order_items, :total_price, true
    change_column_null :order_items, :offer_id, true
    change_column_null :order_items, :order_id, true

  	# Tickets table
  	change_column_null :tickets, :offer_id, true

  	# Ticket_tokens table
  	change_column_null :ticket_tokens, :code, true
  	change_column_null :ticket_tokens, :owner_name, true
  	change_column_null :ticket_tokens, :owner_email, true
  	change_column_null :ticket_tokens, :ticket_id, true
  	change_column_null :ticket_tokens, :ticket_status_id, true

  	# Ticket_statuses table
  	change_column_null :ticket_statuses, :name, true

  	# Company_finances table
  	change_column_null :company_finances, :bank_code, true
  	change_column_null :company_finances, :agencia, true
  	change_column_null :company_finances, :agencia_dv, true
  	change_column_null :company_finances, :conta, true
  	change_column_null :company_finances, :type, true
  	change_column_null :company_finances, :conta_dv, true
  	change_column_null :company_finances, :document_number, true
  	change_column_null :company_finances, :legal_name, true

  	# Event_venues table
  	change_column_null :event_venues, :name, true
  	change_column_null :event_venues, :address, true
  	change_column_null :event_venues, :number, true
  	change_column_null :event_venues, :neighborhood, true
  	change_column_null :event_venues, :city, true
  	change_column_null :event_venues, :state, true
  	change_column_null :event_venues, :zipcode, true

  	# Payments table
  	change_column_null :payments, :tid, true

  	# Validations table
  	change_column_null :validations, :time, true
  	change_column_null :validations, :user_id, true

  	# Credit_cards table
  	change_column_null :credit_cards, :cardid, true
  	change_column_null :credit_cards, :user_id, true

  	# Users table
  	change_column_null :users, :first_name, true
  	change_column_null :users, :last_name, true
  	change_column_null :users, :age, true
  	change_column_null :users, :cpf, true
  	change_column_null :users, :role, true
  end

end

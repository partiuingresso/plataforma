class UpdateTicketTokensNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :ticket_tokens, :code, false
  	change_column_null :ticket_tokens, :owner_name, false
  	change_column_null :ticket_tokens, :owner_email, false
  	change_column_null :ticket_tokens, :ticket_id, false
  	change_column_null :ticket_tokens, :ticket_status_id, false
  end

  def down
  	change_column_null :ticket_tokens, :code, true
  	change_column_null :ticket_tokens, :owner_name, true
  	change_column_null :ticket_tokens, :owner_email, true
  	change_column_null :ticket_tokens, :ticket_id, true
  	change_column_null :ticket_tokens, :ticket_status_id, true
  end

end

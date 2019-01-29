class UpdateTicketStatusesNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :ticket_statuses, :name, false
  end

  def down
  	change_column_null :ticket_statuses, :name, true
  end

end

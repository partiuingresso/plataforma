class UpdateTicketsNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :tickets, :offer_id, false
  end

  def down
  	change_column_null :tickets, :offer_id, true
  end

end

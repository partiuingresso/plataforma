class UpdateEventVenuesNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :event_venues, :name, false
  	change_column_null :event_venues, :address, false
  	change_column_null :event_venues, :number, false
  	change_column_null :event_venues, :neighborhood, false
  	change_column_null :event_venues, :city, false
  	change_column_null :event_venues, :state, false
  	change_column_null :event_venues, :zipcode, false
  end

  def down
  	change_column_null :event_venues, :name, true
  	change_column_null :event_venues, :address, true
  	change_column_null :event_venues, :number, true
  	change_column_null :event_venues, :neighborhood, true
  	change_column_null :event_venues, :city, true
  	change_column_null :event_venues, :state, true
  	change_column_null :event_venues, :zipcode, true
  end

end

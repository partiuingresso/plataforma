class EventsVenuesAddLatitudeLongitude < ActiveRecord::Migration[5.2]
  def change
  	add_column :event_venues, :latitude, :decimal, precision: 10, scale: 8
  	add_column :event_venues, :longitude, :decimal, precision: 11, scale: 8
  	add_index :event_venues, [:latitude, :longitude]
  end
end

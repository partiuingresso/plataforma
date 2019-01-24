class CreateEventVenues < ActiveRecord::Migration[5.2]
  def change
    create_table :event_venues do |t|
      t.string :name
      t.string :address
      t.string :number
      t.string :complement
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :zipcode
      t.timestamps
    end
  end
end

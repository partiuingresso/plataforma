class ChangeEventVenuesTable < ActiveRecord::Migration[5.2]
  def up
  	remove_reference :events, :event_venue
  	rename_table :event_venues, :addresses
  	add_reference :events, :address, null: false, foreign_key: true

  	remove_column :addresses, :number
  	add_column :addresses, :number, :string, null: false
  	rename_column :addresses, :neighborhood, :district
  end

  def down
  	remove_reference :events, :address
  	rename_table :addresses, :event_venues
  	add_reference :events, :event_venue, null: false, foreign_key: true

  	remove_column :event_venues, :number
  	add_column :event_venues, :number, :integer, null: false
  	rename_column :event_venues, :district, :neighborhood

  	execute <<-SQL
			ALTER TABLE event_venues
				ADD CONSTRAINT number_check
					CHECK (number > 0);
	SQL
  end
end

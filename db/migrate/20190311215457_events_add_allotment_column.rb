class EventsAddAllotmentColumn < ActiveRecord::Migration[5.2]
  def up
  	add_column :events, :allotment, :integer, default: 1

  	execute <<-SQL
  		ALTER TABLE events
  			ADD CONSTRAINT allotment_check
  				CHECK (allotment > 0);
  	SQL
  end
  def down
  	execute <<-SQL
  		ALTER TABLE events
  			DROP CONSTRAINT allotment_check;
  	SQL

  	remove_column :events, :allotment
  end
end

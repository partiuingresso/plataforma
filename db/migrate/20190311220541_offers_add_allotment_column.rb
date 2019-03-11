class OffersAddAllotmentColumn < ActiveRecord::Migration[5.2]
  def up
  	remove_column :events, :allotment
  	add_column :offers, :allotment, :integer, default: 1

  	execute <<-SQL
  		ALTER TABLE offers
  			ADD CONSTRAINT allotment_check
  				CHECK (allotment > 0);
  	SQL
  end
  def down
  	add_column :events, :allotment, :integer, default: 1
  	execute <<-SQL
  		ALTER TABLE events
  			ADD CONSTRAINT allotment_check
  				CHECK (allotment > 0);
  		ALTER TABLE offers
  			DROP CONSTRAINT allotment_check;
  	SQL

  	remove_column :offers, :allotment
  end
end

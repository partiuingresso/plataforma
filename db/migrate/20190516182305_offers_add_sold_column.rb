class OffersAddSoldColumn < ActiveRecord::Migration[5.2]
  def up
  	add_column :offers, :sold, :integer, null: false, default: 0

  	execute <<-SQL
  		ALTER TABLE offers
  			ADD CONSTRAINT sold_check
  				CHECK (sold >= 0);
  	SQL
  end

  def down
  	execute <<-SQL
  		ALTER TABLE offers
  			DROP CONSTRAINT sold_check;
  	SQL
  	remove_column :offers, :sold
  end
end

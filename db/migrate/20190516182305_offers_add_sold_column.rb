class OffersAddSoldColumn < ActiveRecord::Migration[5.2]
  def up
  	add_column :offers, :sold, :integer, null: false, default: 0

  	execute <<-SQL
  		ALTER TABLE offers
  			ADD CONSTRAINT sold_check
  				CHECK (sold >= 0 AND sold <= quantity);
      ALTER TABLE offers
        DROP CONSTRAINT quantities_check;
      ALTER TABLE offers
        ADD CONSTRAINT quantity_check
          CHECK (quantity > 0);
  	SQL
  end

  def down
  	execute <<-SQL
  		ALTER TABLE offers
  			DROP CONSTRAINT sold_check;
      ALTER TABLE offers
        DROP CONSTRAINT quantity_check;
      ALTER TABLE offers
        ADD CONSTRAINT quantities_check
          CHECK (quantity > 0 AND available_quantity >= 0 AND available_quantity <= quantity);
  	SQL
  	remove_column :offers, :sold
  end
end

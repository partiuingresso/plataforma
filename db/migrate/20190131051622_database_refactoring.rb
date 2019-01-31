class DatabaseRefactoring < ActiveRecord::Migration[5.2]
  def change
  	drop_table :tickets do |t|
  		t.references :offer, null: false
  		t.timestamps
  	end

  	add_reference :ticket_tokens, :order_item
  	remove_reference :ticket_tokens, :ticket, null: false
  	add_column :offers, :quantity, :integer, null: false
  	add_column :offers, :available_quantity, :integer, null: false
  	add_column :offers, :start_t, :datetime, null: false
  	add_column :offers, :end_t, :datetime

  	reversible do |dir|
  		dir.up do
        remove_column :order_items, :unit_price, :decimal, precision: 10, scale: 2, null: false
  			execute <<-SQL
  				ALTER TABLE offers
  					ADD CONSTRAINT quantities_check
  						CHECK (
  							available_quantity >= 0
  							AND quantity > available_quantity
  						);

  				ALTER TABLE offers
  					ADD CONSTRAINT chronological_order_check
  						CHECK (start_t < end_t);
  			SQL
  		end
  		dir.down do
        add_column :order_items, :unit_price, :decimal, precision: 10, scale: 2, null: false
  			execute <<-SQL
  				ALTER TABLE offers
  					DROP CONSTRAINT quantities_check;

  				ALTER TABLE offers
  					DROP CONSTRAINT chronological_order_check;

                ALTER TABLE order_items
                    ADD CONSTRAINT unit_price_check
                        CHECK (unit_price >= 0);
            SQL
  		end
  	end
  end
end

class UpdateCheckConstraints < ActiveRecord::Migration[5.2]

	def up
		execute <<-SQL
			ALTER TABLE events
				ADD CONSTRAINT chronological_order_check
					CHECK (start_t < end_t);

			ALTER TABLE offers
				ADD CONSTRAINT positive_price_check
					CHECK (price >= 0);

			ALTER TABLE orders
				ADD CONSTRAINT order_number_check
					CHECK (number >= 0);

			ALTER TABLE orders
				ADD CONSTRAINT total_fee_check
					CHECK (
						subtotal >= 0
						AND fee >= 0
						AND fee <= 1
					);

			ALTER TABLE order_items
				ADD CONSTRAINT quantity_check
					CHECK (quantity > 0);

			ALTER TABLE order_items
				ADD CONSTRAINT unit_price_check
					CHECK (unit_price >= 0);

			ALTER TABLE event_venues
				ADD CONSTRAINT number_check
					CHECK (number > 0);

			ALTER TABLE users
				ADD CONSTRAINT age_check
					CHECK (age > 0);
		SQL
	end

	def down
		execute <<-SQL
			ALTER TABLE events
				DROP CONSTRAINT chronological_order_check;

			ALTER TABLE offers
				DROP CONSTRAINT positive_price_check;

			ALTER TABLE orders
				DROP CONSTRAINT order_number_check;

			ALTER TABLE orders
				DROP CONSTRAINT total_fee_check;

			ALTER TABLE order_items
				DROP CONSTRAINT quantity_check;

			ALTER TABLE order_items
				DROP CONSTRAINT unit_price_check;

			ALTER TABLE event_venues
				DROP CONSTRAINT number_check;

			ALTER TABLE users
				DROP CONSTRAINT age_check;
		SQL
	end

end

class FixOfferConstraint < ActiveRecord::Migration[5.2]
	def up
		execute <<-SQL
			ALTER TABLE offers
				DROP CONSTRAINT quantities_check,
				ADD CONSTRAINT quantities_check
					CHECK (
						quantity > 0
						AND available_quantity >= 0
						AND available_quantity <= quantity
					);
		SQL
	end
	def down
		execute <<-SQL
			ALTER TABLE offers
				DROP CONSTRAINT quantities_check,
				ADD CONSTRAINT quantities_check
					CHECK (
						available_quantity >= 0
						AND quantity > available_quantity
					);
		SQL
	end
end

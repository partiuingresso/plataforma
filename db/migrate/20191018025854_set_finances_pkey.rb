class SetFinancesPkey < ActiveRecord::Migration[5.2]
  def change
  	execute <<-SQL
  		ALTER TABLE finances DROP COLUMN id;
  		ALTER TABLE finances ADD COLUMN id SERIAL PRIMARY KEY;
  	SQL
  end
end

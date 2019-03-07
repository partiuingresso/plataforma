class CreateTransfers < ActiveRecord::Migration[5.2]
  def up
    create_table :transfers do |t|
    	t.references :company, foreign_key: true, null: false
    	t.references :bank_account, foreign_key: true, null: false
    	t.integer :amount_cents, null: false
    	t.decimal :fee, precision: 3, scale: 2, null: false
      t.timestamps
    end

		execute <<-SQL
			CREATE TYPE transfer_status AS ENUM ('requested', 'completed', 'failed', 'reversed');
		SQL
		add_column :transfers, :status, :transfer_status, null: false, default: 'requested'
  end
  def down
  	drop_table :transfers

		execute <<-SQL
			DROP TYPE transfer_status;
		SQL
  end
end

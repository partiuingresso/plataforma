class CreateOrderPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :order_payments, id: false do |t|
    	t.references :order, primary_key: true, foreign_key: true, null: false
    	t.integer :amount_cents, null: false, default: 0
      t.string :card_brand, null: false
    	t.integer :card_number_last_4, null: false
    	t.integer :installment_count, null: false, default: 1
    	t.decimal :interest_rate, precision: 6, scale: 5, null: false, default: 0
    	t.decimal :service_fee, precision: 3, scale: 2, null: false
      t.timestamps
    end
  end
end

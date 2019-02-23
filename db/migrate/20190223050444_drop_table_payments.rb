class DropTablePayments < ActiveRecord::Migration[5.2]
  def up
  	drop_table :payments
  end
  def down
		create_table "payments", primary_key: "order_id", id: :bigint, default: nil, force: :cascade do |t|
			t.string "tid", null: false
			t.datetime "created_at", null: false
			t.datetime "updated_at", null: false
			t.index ["order_id"], name: "index_payments_on_order_id"
		end

	  add_foreign_key :payments, :orders
  end
end

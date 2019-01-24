class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :number
      t.decimal :subotal, precision: 10, scale: 2
      t.decimal :fee, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.references :payment
      t.references :order_status, index: true
      t.timestamps
    end
  end
end

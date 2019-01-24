class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.references :offer, index: true
      t.references :order, index: true

      t.integer :quantity
      t.decimal :unit_price, precision: 10, scale: 2
      t.decimal :total_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end

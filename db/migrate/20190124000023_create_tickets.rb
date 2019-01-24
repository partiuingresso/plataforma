class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.references :offer
      t.references :order_item

      t.timestamps
    end
  end
end

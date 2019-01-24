class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.references :event
      t.timestamps
    end
  end
end

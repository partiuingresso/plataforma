class CreateSellerStaff < ActiveRecord::Migration[5.2]
  def change
    create_table :seller_staff do |t|
    	t.references :seller, foreign_key: true, null: false
      t.timestamps
    end
  end
end

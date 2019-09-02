class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
    	t.references :seller, foreign_key: true, null: false, index: { unique: true }
    	t.references :address, foreign_key: true, null: false
    	t.string :name, null: false
    	t.string :business_name, null: false
    	t.string :document_number, null: false
    	t.integer :phone_area_code, null: false
    	t.integer :phone_number, null: false
      t.timestamps
    end

  end
end

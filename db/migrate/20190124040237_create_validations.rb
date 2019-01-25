class CreateValidations < ActiveRecord::Migration[5.2]
  def change
    create_table :validations do |t|
      t.references :user
      t.datetime :time
      t.timestamps
    end
  end
end
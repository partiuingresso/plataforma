class CreateEventStaffs < ActiveRecord::Migration[5.2]
  def change
    create_table :event_staff do |t|
    	t.references :event, foreign_key: true, null: false
      t.timestamps
    end
  end
end

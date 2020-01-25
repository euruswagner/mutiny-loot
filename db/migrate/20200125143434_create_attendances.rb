class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.string :notes
      t.integer :points
      t.timestamps
    end
  end
end

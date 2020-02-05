class AddRaiderToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :raider_id, :integer
  end
end

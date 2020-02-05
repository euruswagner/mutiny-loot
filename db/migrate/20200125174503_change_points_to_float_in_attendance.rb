class ChangePointsToFloatInAttendance < ActiveRecord::Migration[5.2]
  def change
    change_column :attendances, :points, :float
  end
end

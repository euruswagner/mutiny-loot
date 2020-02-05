class ChangePointsSpentToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :winners, :points_spent, :float
  end
end

class ChangePointsSpentandPointsEarnedForRaiders < ActiveRecord::Migration[5.2]
  def change
    rename_column :raiders, :points_earned, :total_points_earned
    rename_column :raiders, :points_spent, :total_points_spent
  end
end

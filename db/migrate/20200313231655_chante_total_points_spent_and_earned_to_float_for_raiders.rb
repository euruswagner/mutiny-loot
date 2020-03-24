class ChanteTotalPointsSpentAndEarnedToFloatForRaiders < ActiveRecord::Migration[5.2]
  def change
    change_column :raiders, :total_points_spent, :float
    change_column :raiders, :total_points_earned, :float
  end
end

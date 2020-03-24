class ChangeRaidersTotalPointsEarnedAndSpentToDefaultToZero < ActiveRecord::Migration[5.2]
  def change
    change_column :raiders, :total_points_spent, :float, null: 0.0, default: 0
    change_column :raiders, :total_points_earned, :float, null: 0.0, default: 0
  end
end

module RaidersHelper
  def points_earned(raider)
    return raider.attendances.sum('points')
  end

  def points_spent(raider)
    return raider.winners.sum('points_spent')
  end

  def total_points(raider)
    total_points = points_earned(raider) - points_spent(raider)
    return total_points if total_points > 0
    return 0.0
  end
end

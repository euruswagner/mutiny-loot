module RaidersHelper
  def points_earned(raider)
    return raider.attendances.sum('points')
  end
end

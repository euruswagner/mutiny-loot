class Priority < ApplicationRecord
  belongs_to :raider
  belongs_to :item
  
  def points_worth
    raider = self.raider
    total_points = total_points(raider)
    if max_points >= total_points
      return total_points
    elsif max_points < total_points
      return max_points
    else 
      return 0
    end
  end

  def points_earned(raider)
    return raider.attendances.sum('points')
  end

  def points_spent(raider)
    return raider.winners.sum('points_spent')
  end

  def total_points(raider)
    total_points = points_earned(raider) - points_spent(raider)
    return total_points.round(1) 
  end

  def max_points
    if ranking >= 48
      return 3.6
    elsif ranking <= 47 && ranking >= 45
      return 2.0
    elsif ranking <= 44 && ranking >= 42
      return 0.8
    else 
      return 0
    end
  end

  validates :ranking, presence: true
end

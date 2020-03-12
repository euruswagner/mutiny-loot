class Priority < ApplicationRecord
  belongs_to :raider
  belongs_to :item
  
  def points_worth
    raider = self.raider
    net_points = raider.net_points
    if max_points >= net_points
      return net_points
    elsif max_points < net_points
      return max_points
    else 
      return 0
    end
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

  def total_item_value_for_raider
    net_points = self.raider.net_points
    ranking = self.ranking
    weeks_with_the_guild = self.raider.weeks_with_the_guild?
    if self.item.primary_class?(self.raider) then 
      item_value = ranking + net_points
    else
      item_value = (ranking + net_points)/2
    end
    if self.item.zone == 'Blackwing Lair'
      return 0 if weeks_with_the_guild < 3
      return item_value - 3 if weeks_with_the_guild < 4
      return item_value - 1 if weeks_with_the_guild < 5
      return item_value
    else
      return 0 if weeks_with_the_guild < 2
      return item_value - 3 if weeks_with_the_guild < 3
      return item_value - 1 if weeks_with_the_guild < 4
      return item_value
    end 
  end

  validates :ranking, presence: true
end

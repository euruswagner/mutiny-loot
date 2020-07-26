class Priority < ApplicationRecord
  belongs_to :raider
  belongs_to :item
  has_one :winner
  
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
  
  def points_worth
    raider = self.raider
    net_points = raider.net_points
    # if max_points >= net_points
    #   if raider.enchanted? && raider.warlock?
    #     return (net_points - 0.2).round(2)
    #   elsif raider.enchanted? || raider.warlock?
    #     return(net_points -0.1).round(2)
    #   else
    #     return net_points.round(2)
    #   end
    # elsif max_points < net_points
    #   return max_points.round(2)
    # else 
    #   return 0
    # end
    if raider.enchanted? && raider.warlock?
      if max_points >= (net_points - 0.2).round(2)
        return (net_points - 0.2).round(2)
      elsif max_points < (net_points - 0.2)
        return max_points.round(2)
      else
        return 0
      end
    elsif raider.enchanted? || raider.warlock?
      if max_points >= (net_points - 0.1).round(2)
        return (net_points - 0.1).round(2)
      elsif max_points < (net_points - 0.1)
        return max_points.round(2)
      else
        return 0
      end
    else
      if max_points >= net_points
        return net_points.round(2)
      elsif max_points < net_points
        return max_points.round(2)
      else
        return 0
      end
    end
  end

  def phase_3_total_item_value_for_raider
    net_points = self.raider.net_points
    ranking = self.ranking
    weeks_with_the_guild = self.raider.weeks_with_the_guild?
    if self.item.primary_class?(self.raider) then 
      item_value = ranking + net_points
    else
      item_value = ((ranking + net_points)/2).round(2)
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

  def phase_5_total_item_value_for_raider
    net_points = self.raider.net_points
    ranking = self.ranking
    weeks_with_the_guild = self.raider.weeks_with_the_guild?
    if self.item.primary_class?(self.raider) then 
      item_value = ranking + net_points
    else
      item_value = ((ranking + net_points) * 0.75).round(2)
    end
    if self.item.zone == 'Temple of Ahn\'Qiraj'
      if self.item.unlimited?  
        return 0 if weeks_with_the_guild < 3
        return item_value - 3 if weeks_with_the_guild < 4
        return item_value - 1 if weeks_with_the_guild < 5
        return item_value
      else
        return 0 if weeks_with_the_guild < 4
        return item_value - 2 if weeks_with_the_guild < 5
        return item_value - 1 if weeks_with_the_guild < 6
        return item_value
      end
    elsif self.item.zone == 'Blackwing Lair'
      if self.item.unlimited?  
        return 0 if weeks_with_the_guild < 2
        return item_value - 3 if weeks_with_the_guild < 3
        return item_value - 1 if weeks_with_the_guild < 4
        return item_value
      else
        return 0 if weeks_with_the_guild < 3
        return item_value - 2 if weeks_with_the_guild < 4
        return item_value - 1 if weeks_with_the_guild < 5
        return item_value
      end
    else
      if self.item.unlimited?  
        return item_value - 3 if weeks_with_the_guild < 2
        return item_value - 1 if weeks_with_the_guild < 3
        return item_value
      else
        return 0 if weeks_with_the_guild < 2
        return item_value - 2 if weeks_with_the_guild < 3
        return item_value - 1 if weeks_with_the_guild < 4
        return item_value
      end
    end 
  end

  def valid_priority?(ranking)
    return false if self.more_then_two_per_row?(ranking)
    return true if ranking < 42
    return false unless self.primary_class?
    return false if self.moving_reserved_item_to_occupied_row?(ranking)
    return false if self.reserved_item_in_row?(ranking)
    return false if self.more_then_three_allocation_points_in_bracket?(ranking)
    return false if self.multiple_items_with_the_same_category?(ranking)
    return true
  end

  def more_then_two_per_row?(ranking)
    current_number_on_row = self.raider.priorities.where(phase: 5, ranking: ranking).count
    return current_number_on_row >= 2
  end

  def primary_class?
    item = self.item
    raider = self.raider
    return item.primary_class?(raider)
  end

  def moving_reserved_item_to_occupied_row?(ranking)
    return false if self.item.classification != 'Reserved'
    return self.raider.priorities.where(phase: 5, ranking: ranking).any?
  end

  def reserved_item_in_row?(ranking)
    priority_with_same_ranking = self.raider.priorities.where(phase: 5, ranking: ranking)
    return false if priority_with_same_ranking.blank?
    item_on_row = priority_with_same_ranking.first.item
    return true if item_on_row.classification == 'Reserved'
    return false
  end

  def more_then_three_allocation_points_in_bracket?(ranking)
    return false if self.item.classification == 'Unlimited'
    if ranking <= 50 && ranking > 47
      bracket = [50, 49, 48]
    elsif ranking <= 47 && ranking > 44
      bracket = [47, 46, 45]
    else
      bracket = [44, 43, 42]
    end
    priorities_in_bracket = []
    allocation_points_in_bracket = 0
    
    bracket.each do |ranking|
      priorities_in_bracket << self.raider.priorities.where(phase: 5, ranking: ranking)
    end

    priorities_in_bracket.flatten.each do |priority|
      if priority.id == self.id
        next
      elsif priority.item.classification == 'Reserved' || priority.item.classification == 'Limited'
        allocation_points_in_bracket += 1
      else
        next
      end
    end

    return allocation_points_in_bracket >= 2 if self.raider.which_class == 'Hunter'
    return allocation_points_in_bracket >= 3
  end

  def multiple_items_with_the_same_category?(ranking)
    if ranking <= 50 && ranking > 47
      bracket = [50, 49, 48]
    elsif ranking <= 47 && ranking > 44
      bracket = [47, 46, 45]
    else
      bracket = [44, 43, 42]
    end
    priorities_in_bracket = []

    bracket.each do |ranking|
      priorities_in_bracket << self.raider.priorities.where(phase: 5, ranking: ranking)
    end
    priorities_in_bracket.flatten.each do |priority|
      next if priority.id == self.id
      return true if priority.item.category == self.item.category
      return true if priority.item.category == self.item.category.split.first
      return true if priority.item.category == self.item.category.split.last
      return true if priority.item.category.split.first == self.item.category
      return true if priority.item.category.split.last == self.item.category
      next
    end
    return false
  end

  validates :ranking, numericality: {greater_than: 17, less_than_or_equal_to: 50}, presence: true
end

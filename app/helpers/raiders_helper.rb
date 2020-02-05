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

  def class_color(raider)
    return 'warrior' if raider.which_class == 'Warrior'
    return 'rogue' if raider.which_class == 'Rogue'
    return 'hunter' if raider.which_class == 'Hunter'
    return 'mage' if raider.which_class == 'Mage'
    return 'warlock' if raider.which_class == 'Warlock'
    return 'priest' if raider.which_class == 'Priest'
    return 'shaman' if raider.which_class == 'Shaman'
    return 'druid' if raider.which_class == 'Druid' 
    return ''
  end
end

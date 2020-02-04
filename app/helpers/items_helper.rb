module ItemsHelper
  def ordered_list_of_priorities(item)
    ary_of_raiders_with_total_priority = []
    item.priorities.each do |priority|
      next if won_that_item(item, priority)

      points_earned = priority.raider.attendances.sum(:points)
      points_spent = priority.raider.winners.sum(:points_spent)
      if points_earned - points_spent > 0 then
        total_points = points_earned - points_spent
      else
        total_points = 0
      end
      ranking = priority.ranking
      adjusted_ranking = ranking + total_points
      raider = priority.raider.name
      ary_of_raiders_with_total_priority << "#{adjusted_ranking} - #{raider}"
    end
    ary_of_raiders_with_total_priority_sorted = ary_of_raiders_with_total_priority.sort.reverse
    return ary_of_raiders_with_total_priority_sorted
  end

  def won_that_item(item, priority)
    return false if item.winners.empty?
    item.winners.each do |winner|
      if winner.raider_id == priority.raider_id
        return true
      else
        next
      end
    end
    return false
  end

  def raiders_without_priority_assigned(item)
    raiders_without_priority_assigned = []
    @raiders.each do |raider|
      next if does_have_priority_assigned(item, raider)
      raiders_without_priority_assigned << raider
    end
    return raiders_without_priority_assigned
  end

  def does_have_priority_assigned(item, raider)
    return false if raider.priorities.empty?
    priorities_for_this_item = raider.priorities.find do |priority|
      priority.item_id == item.id
    end
    return priorities_for_this_item
  end

  def melee_without_priority_assigned(item)
    melee = []
    raiders_without_priority_assigned(item).each do |raider|
      if raider.which_class == 'Warrior' || raider.which_class == 'Rogue'
        melee << raider
      elsif raider.role == 'Enhancement' || raider.role == 'Feral'
        melee << raider
      else
        next
      end
    end
    return melee
  end

  def ranged_without_priority_assigned(item)
    ranged = []
    raiders_without_priority_assigned(item).each do |raider|
      if raider.which_class == 'Hunter' || raider.which_class == 'Mage' || raider.which_class == 'Warlock'
        ranged << raider
      elsif raider.role == 'Shadow' || raider.role == 'Moonkin'
        ranged << raider
      else
        next
      end
    end
    return ranged
  end

  def healers_without_priority_assigned(item)
    healers = []
    raiders_without_priority_assigned(item).each do |raider|
      if raider.role == 'Healer' 
        healers << raider
      else
        next
      end
    end
    return healers
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

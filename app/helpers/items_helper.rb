module ItemsHelper
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
    unsorted_melee = []
    raiders_without_priority_assigned(item).each do |raider|
      if raider.which_class == 'Warrior' || raider.which_class == 'Rogue'
        unsorted_melee << raider
      elsif raider.role == 'Enhancement' || raider.role == 'Feral'
        unsorted_melee << raider
      else
        next
      end
    end
    warrior = []
    rogue = []
    enhancement = []
    feral = []
    unsorted_melee.each do |melee|
      if melee.which_class == 'Warrior'
        warrior << melee
      elsif melee.which_class == 'Rogue'
        rogue << melee
      elsif melee.role == 'Enhancement'
        enhancement << melee
      else
        feral << melee
      end
    end
    sorted_melee = warrior + rogue + enhancement + feral
    return sorted_melee
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

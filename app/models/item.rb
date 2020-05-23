class Item < ApplicationRecord
  has_many :priorities, dependent: :destroy
  has_many :winners, dependent: :destroy

  def phase_3?
    return true if zone.nil? || zone == ''
    return zone == 'Blackwing Lair' || zone == 'Lord Kazzak' || zone == 'Azuregos' || zone == 'Molten Core' || zone == 'Onyxia'
  end

  def primary_class?(raider)
    return true if priority.nil?
    return true if priority == ''
    return true if priority == 'All'
    primary_class_ary = priority.split()
    primary_class_ary.each do |priority|
      return true if priority == raider.which_class
      return true if priority == raider.role
    end
    return false
  end

  def phase_3_ordered_list_of_priorities
    priorities_that_have_not_won = []
    self.priorities.each do |priority|
      next if priority.phase != 3
      next if priority.raider.role == 'Retired'
      next if self.won_this_item?(priority)
      priorities_that_have_not_won << priority
    end
    return priorities_that_have_not_won.sort { |a, b| b.phase_3_total_item_value_for_raider <=> a.phase_3_total_item_value_for_raider}
  end

  def phase_5_ordered_list_of_priorities
    priorities_that_have_not_won = []
    self.priorities.each do |priority|
      next if priority.phase != 5
      next if priority.raider.role == 'Retired'
      next if self.won_this_item?(priority)
      priorities_that_have_not_won << priority
    end
    return priorities_that_have_not_won.sort { |a, b| b.phase_5_total_item_value_for_raider <=> a.phase_5_total_item_value_for_raider}
  end

  def won_this_item?(priority)
    return false if self.winners.empty?
    self.winners.each do |winner|
      if winner.raider_id == priority.raider_id
        return true
      else
        next
      end
    end
    return false
  end
  
  ZONES = {
    'Naxxramas': 'Naxxramas',
    'Temple of Ahn\'Qiraj': 'Temple of Ahn\'Qiraj',
    'Nightmare Dragons': 'Nightmare Dragons',
    'Emeriss': 'Emeriss',
    'Lethon': 'Lethon',
    'Taerar': 'Taerar',
    'Ysondre': 'Ysondre',
    'Blackwing Lair': 'Blackwing Lair',
    'Lord Kazzak': 'Lord Kazzak',
    'Azuregos': 'Azuregos',
    'Molten Core': 'Molten Core',
    'Onyxia': 'Onyxia'
  }

  PRIORITY = {
    'All': 'All',
    'Warrior': 'Warrior',
    'Rogue': 'Rogue',
    'Hunter': 'Hunter',
    'Mage': 'Mage',
    'Warlock': 'Warlock',
    'Priest': 'Priest',
    'Shaman': 'Shaman',
    'Druid': 'Druid',
    'Tank': 'Tank',
    'Fury': 'Fury',
    'Healer': 'Healer',
    'Warrior Rogue': 'Warrior Rogue',
    'Warrior Rogue Hunter': 'Warrior Rogue Hunter',
    'Warrior Rogue Hunter Mage Warlock': 'Warrior Rogue Hunter Mage Warlock',
    'Warrior Rogue Hunter Feral Enhancement': 'Warrior Rogue Hunter Feral Enhancement',
    'Warrior Rogue Mage': 'Warrior Rogue Mage',
    'Warrior Rogue Shaman': 'Warrior Rogue Shaman',
    'Warrior Rogue Feral': 'Warrior Rogue Feral',
    'Warrior Hunter': 'Warrior Hunter',
    'Warrior Shaman': 'Warrior Shaman',
    'Warrior Hunter Shaman': 'Warrior Hunter Shaman',
    'Warrior Hunter Enhancement': 'Warrior Hunter Enhancement',
    'Warrior Mage Warlock': 'Warrior Mage Warlock',
    'Warrior Feral': 'Warrior Feral',
    'Warrior Feral Enhancement': 'Warrior Feral Enhancement',
    'Rogue Hunter': 'Rogue Hunter',
    'Rogue Hunter Tank': 'Rogue Hunter Tank',
    'Rogue Shaman': 'Rogue Shaman',
    'Rogue Tank': 'Rogue Tank',
    'Rogue Feral': 'Rogue Feral',
    'Rogue Feral Enhancement': 'Rogue Feral Enhancement',
    'Hunter Shaman': 'Hunter Shaman',
    'Hunter Enhancement': 'Hunter Enhancement',
    'Hunter Feral Enhancement': 'Hunter Feral Enhancement',
    'Mage Warlock': 'Mage Warlock',
    'Mage Warlock Priest': 'Mage Warlock Priest',
    'Mage Warlock Priest Shaman Druid': 'Mage Warlock Priest Shaman Druid',
    'Mage Warlock Shaman': 'Mage Warlock Shaman',
    'Mage Warlock Shadow': 'Mage Warlock Shadow',
    'Mage Warlock Shadow Tank': 'Mage Warlock Shadow Tank',
    'Mage Warlock Shadow Moonkin Elemental': 'Mage Warlock Shadow Moonkin Elemental',
    'Warlock Shaman': 'Warlock Shaman',
    'Warlock Shadow': 'Warlock Shadow',
    'Shaman Druid': 'Shaman Druid',
    'Feral Enhancement': 'Feral Enhancement',
    'Feral Enhancement Fury': 'Feral Enhancement Fury',
    'Balance Elemental': 'Balance Elemental'
  }

  CLASSIFICATIONS = {
    'Reserved': 'Reserved',
    'Limited': 'Limited',
    'Unlimited': 'Unlimited'
  }

  CATEGORY = {
    'Head': 'Head',
    'Neck': 'Neck',
    'Shoulders': 'Shoulders',
    'Back': 'Back',
    'Chest': 'Chest',
    'Wrists': 'Wrists',
    'Hands': 'Hands',
    'Waist': 'Waist',
    'Legs': 'Legs',
    'Feet': 'Feet',
    'Ring': 'Ring',
    'Trinket': 'Trinket',
    'Melee': 'Melee',
    'Offhand': 'Offhand',
    'Ranged': 'Ranged',
    'Shoulders and Feet': 'Shoulders and Feet'
  }
end

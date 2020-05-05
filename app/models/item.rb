class Item < ApplicationRecord
  belongs_to :category

  has_many :priorities, dependent: :destroy
  has_many :winners, dependent: :destroy

  def primary_class?(raider)
    return true if priority.nil?
    return true if priority == ''
    primary_class_ary = priority.split()
    primary_class_ary.each do |priority|
      return true if priority == raider.which_class
      return true if priority == raider.role
    end
    return false
  end

  def ordered_list_of_priorities
    priorities_that_have_not_won = []
    self.priorities.each do |priority|
      next if priority.raider.role == 'Retired'
      next if self.won_this_item?(priority)
      priorities_that_have_not_won << priority
    end
    return priorities_that_have_not_won.sort { |a, b| b.total_item_value_for_raider <=> a.total_item_value_for_raider}
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
    'Blackwing Lair': 'Blackwing Lair',
    'Molten Core': 'Molten Core',
    'Onyxia': 'Onyxia'
  }

  CLASSIFICATIONS = {
    'Reserved': 'Reserved',
    'Limited': 'Limited',
    'Unlimited': 'Unlimited'
  }
end

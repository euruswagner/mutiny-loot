class Item < ApplicationRecord
  belongs_to :category

  has_many :comments, dependent: :destroy
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

  def raiders_without_priority_assigned
    raiders_without_priority_assigned = []
    raiders = Raider.all
    raiders.each do |raider|
      next if raider.role == 'Retired'
      next if does_have_priority_assigned(raider)
      raiders_without_priority_assigned << raider
    end
    return raiders_without_priority_assigned
  end

  def does_have_priority_assigned(raider)
    return false if raider.priorities.empty?
    priorities_for_this_item = raider.priorities.find do |priority|
      priority.item_id == self.id
    end
    return priorities_for_this_item
  end 

  def warriors_without_priority_assigned
    warriors_without_priority_assigned = []
    self.raiders_without_priority_assigned.each do |raider|
      next if not raider.warrior?
      warriors_without_priority_assigned << raider
    end
    return warriors_without_priority_assigned
  end

  def rogues_without_priority_assigned
    rogues_without_priority_assigned = []
    self.raiders_without_priority_assigned.each do |raider|
      next if not raider.rogue?
      rogues_without_priority_assigned << raider
    end
    return rogues_without_priority_assigned
  end

  def hunters_without_priority_assigned
    hunters_without_priority_assigned = []
    self.raiders_without_priority_assigned.each do |raider|
      next if not raider.hunter?
      hunters_without_priority_assigned << raider
    end
    return hunters_without_priority_assigned
  end

  def mages_without_priority_assigned
    mages_without_priority_assigned = []
    self.raiders_without_priority_assigned.each do |raider|
      next if not raider.mage?
      mages_without_priority_assigned << raider
    end
    return mages_without_priority_assigned
  end

  def warlocks_without_priority_assigned
    warlocks_without_priority_assigned = []
    self.raiders_without_priority_assigned.each do |raider|
      next if not raider.warlock?
      warlocks_without_priority_assigned << raider
    end
    return warlocks_without_priority_assigned
  end

  def priests_without_priority_assigned
    priests_without_priority_assigned = []
    self.raiders_without_priority_assigned.each do |raider|
      next if not raider.priest?
      priests_without_priority_assigned << raider
    end
    return priests_without_priority_assigned
  end

  def shamans_without_priority_assigned
    shamans_without_priority_assigned = []
    self.raiders_without_priority_assigned.each do |raider|
      next if not raider.shaman?
      shamans_without_priority_assigned << raider
    end
    return shamans_without_priority_assigned
  end

  def druids_without_priority_assigned
    druids_without_priority_assigned = []
    self.raiders_without_priority_assigned.each do |raider|
      next if not raider.druid?
      druids_without_priority_assigned << raider
    end
    return druids_without_priority_assigned
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

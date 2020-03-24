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

  def active_warriors_without_priority_assigned_or_have_not_won_this_item
    active_eager_warriors = Raider.where(which_class: 'Warrior').where.not(role: 'Retired').includes(:priorities, :winners)
    item_id = self.id
    warriors_with_priority_assigned = active_eager_warriors.joins(:priorities).where("priorities.item_id = #{item_id}")
    warriors_that_have_won = active_eager_warriors.joins(:winners).where("winners.item_id = #{item_id}")
    active_warriors_without_priority_assigned = active_eager_warriors - warriors_with_priority_assigned - warriors_that_have_won
    return active_warriors_without_priority_assigned
  end

  def active_rogues_without_priority_assigned_or_have_not_won_this_item
    active_eager_rogues = Raider.where(which_class: 'Rogue').where.not(role: 'Retired').includes(:priorities, :winners)
    item_id = self.id
    rogues_with_priority_assigned = active_eager_rogues.joins(:priorities).where("priorities.item_id = #{item_id}")
    rogues_that_have_won = active_eager_rogues.joins(:winners).where("winners.item_id = #{item_id}")
    active_rogues_without_priority_assigned = active_eager_rogues - rogues_with_priority_assigned - rogues_that_have_won
    return active_rogues_without_priority_assigned
  end
  
  def active_hunters_without_priority_assigned_or_have_not_won_this_item
    active_eager_hunters = Raider.where(which_class: 'Hunter').where.not(role: 'Retired').includes(:priorities, :winners)
    item_id = self.id
    hunters_with_priority_assigned = active_eager_hunters.joins(:priorities).where("priorities.item_id = #{item_id}")
    hunters_that_have_won = active_eager_hunters.joins(:winners).where("winners.item_id = #{item_id}")
    active_hunters_without_priority_assigned = active_eager_hunters - hunters_with_priority_assigned - hunters_that_have_won
    return active_hunters_without_priority_assigned
  end
  
  def active_mages_without_priority_assigned_or_have_not_won_this_item
    active_eager_mages = Raider.where(which_class: 'Mage').where.not(role: 'Retired').includes(:priorities, :winners)
    item_id = self.id
    mages_with_priority_assigned = active_eager_mages.joins(:priorities).where("priorities.item_id = #{item_id}")
    mages_that_have_won = active_eager_mages.joins(:winners).where("winners.item_id = #{item_id}")
    active_mages_without_priority_assigned = active_eager_mages - mages_with_priority_assigned - mages_that_have_won
    return active_mages_without_priority_assigned
  end

  def active_warlocks_without_priority_assigned_or_have_not_won_this_item
    active_eager_warlocks = Raider.where(which_class: 'Warlock').where.not(role: 'Retired').includes(:priorities, :winners)
    item_id = self.id
    warlocks_with_priority_assigned = active_eager_warlocks.joins(:priorities).where("priorities.item_id = #{item_id}")
    warlocks_that_have_won = active_eager_warlocks.joins(:winners).where("winners.item_id = #{item_id}")
    active_warlocks_without_priority_assigned = active_eager_warlocks - warlocks_with_priority_assigned - warlocks_that_have_won
    return active_warlocks_without_priority_assigned
  end

  def active_priests_without_priority_assigned_or_have_not_won_this_item
    active_eager_priests = Raider.where(which_class: 'Priest').where.not(role: 'Retired').includes(:priorities, :winners)
    item_id = self.id
    priests_with_priority_assigned = active_eager_priests.joins(:priorities).where("priorities.item_id = #{item_id}")
    priests_that_have_won = active_eager_priests.joins(:winners).where("winners.item_id = #{item_id}")
    active_priests_without_priority_assigned = active_eager_priests - priests_with_priority_assigned - priests_that_have_won
    return active_priests_without_priority_assigned
  end

  def active_shamans_without_priority_assigned_or_have_not_won_this_item
    active_eager_shamans = Raider.where(which_class: 'Shaman').where.not(role: 'Retired').includes(:priorities, :winners)
    item_id = self.id
    shamans_with_priority_assigned = active_eager_shamans.joins(:priorities).where("priorities.item_id = #{item_id}")
    shamans_that_have_won = active_eager_shamans.joins(:winners).where("winners.item_id = #{item_id}")
    active_shamans_without_priority_assigned = active_eager_shamans - shamans_with_priority_assigned - shamans_that_have_won
    return active_shamans_without_priority_assigned
  end

  def active_druids_without_priority_assigned_or_have_not_won_this_item
    active_eager_druids = Raider.where(which_class: 'Druid').where.not(role: 'Retired').includes(:priorities, :winners)
    item_id = self.id
    druids_with_priority_assigned = active_eager_druids.joins(:priorities).where("priorities.item_id = #{item_id}")
    druids_that_have_won = active_eager_druids.joins(:winners).where("winners.item_id = #{item_id}")
    active_druids_without_priority_assigned = active_eager_druids - druids_with_priority_assigned - druids_that_have_won
    return active_druids_without_priority_assigned
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

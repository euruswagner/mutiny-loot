class Raider < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :priorities, dependent: :destroy
  has_many :winners, dependent: :destroy

  def points_earned
    return 0 if self.attendances.nil?
    return self.attendances.sum('points') 
  end

  def points_spent
    return 0 if self.winners.nil?
    return self.winners.sum('points_spent') 
  end

  def net_points
    net_points = self.points_earned - self.points_spent
    return net_points.round(1)
  end

  def weeks_with_the_guild?
    return 0 if self.attendances.first.nil?
    return ((Time.now - self.attendances.first.created_at)/60/60/24/7) + 1.36
  end

  def melee?
    if which_class == 'Warrior' || which_class == 'Rogue'
      return true
    elsif role == 'Enhancement' || role == 'Feral'
      return true
    else
      return false
    end
  end 

  def ranged?
    if which_class == 'Hunter' || which_class == 'Mage' || which_class == 'Warlock'
      return true
    elsif role == 'Shadow' || role == 'Elemental' || role == 'Moonkin'
      return true
    else
      return false
    end
  end

  def healer?
    return role =='Healer'
  end

  def warrior?
    return which_class == 'Warrior'
  end

  def rogue?
    return which_class == 'Rogue'
  end

  def hunter?
    return which_class == 'Hunter'
  end

  def mage?
    return which_class == 'Mage'
  end

  def warlock?
    return which_class == 'Warlock'
  end

  def priest?
    return which_class == 'Priest'
  end

  def druid?
    return which_class == 'Druid'
  end

  def shaman?
    return which_class == 'Shaman'
  end

  WHICH_CLASS = {
    'Warrior': 'Warrior',
    'Rogue': 'Rogue',
    'Hunter': 'Hunter',
    'Mage': 'Mage',
    'Warlock': 'Warlock',
    'Priest': 'Priest',
    'Druid': 'Druid',
    'Shaman': 'Shaman'
  }

  ROLE = {
    'Tank': 'Tank',
    'Healer': 'Healer',
    'DPS': 'DPS',
    'Fury': 'Fury',
    'Enhancement': 'Enhancement',
    'Feral': 'Feral',
    'Shadow': 'Shadow',
    'Elemental': 'Elemental',
    'Moonkin': 'Moonkin',    
    'Retired': 'Retired'
  }

  validates :name, presence: true
  validates :which_class, presence: true
  validates :role, presence: true
end

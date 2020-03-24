class Raider < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :priorities, dependent: :destroy
  has_many :winners, dependent: :destroy
  scope :active, -> { where.not(role: 'Retired')}
  scope :warrior, -> { where(which_class: 'Warrior') }
  scope :rogue, -> { where(which_class: 'Rogue') }

  def net_points
    net_points = self.total_points_earned - self.total_points_spent
    return net_points.round(1)
  end

  def update_total_points_spent(points_spent)
    old_total_points_spent = self.total_points_spent
    up_to_date_total_points_spent = old_total_points_spent + points_spent
    self.write_attribute(:total_points_spent, up_to_date_total_points_spent)
    self.save!
  end

  def update_total_points_earned(points_earned)
    old_total_points_earned = self.total_points_earned
    up_to_date_total_points_earned = old_total_points_earned + points_earned
    self.write_attribute(:total_points_earned, up_to_date_total_points_earned)
    self.save!
  end
  
  def weeks_with_the_guild?
    return 0 if self.attendances.first.nil?
    return ((Time.now - self.attendances.first.created_at)/60/60/24/7) + 1.36
  end

  def melee
    melee = Raider.where(which_class: 'Warrior')
    return melee
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

  def class_color
    return 'warrior' if self.which_class == 'Warrior'
    return 'rogue' if self.which_class == 'Rogue'
    return 'hunter' if self.which_class == 'Hunter'
    return 'mage' if self.which_class == 'Mage'
    return 'warlock' if self.which_class == 'Warlock'
    return 'priest' if self.which_class == 'Priest'
    return 'shaman' if self.which_class == 'Shaman'
    return 'druid' if self.which_class == 'Druid' 
    return ''
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

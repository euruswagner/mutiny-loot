class Raider < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :priorities, dependent: :destroy
  has_many :winners, dependent: :destroy

  def weeks_with_the_guild?
    return 0 if self.attendances.first.nil?
    return ((Time.now - self.attendances.first.created_at)/60/60/24/7) + 1.36
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
    'Retired': 'Retired'
  }

  validates :name, presence: true
  validates :which_class, presence: true
  validates :role, presence: true
end

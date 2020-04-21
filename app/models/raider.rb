class Raider < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :priorities, dependent: :destroy
  has_many :winners, dependent: :destroy
  belongs_to :user, optional: true
  scope :active, -> { where.not(role: 'Retired')}
  scope :warrior, -> { where(which_class: 'Warrior') }
  scope :rogue, -> { where(which_class: 'Rogue') }
  scope :hunter, -> { where(which_class: 'Hunter') }
  scope :mage, -> { where(which_class: 'Mage') }
  scope :warlock, -> { where(which_class: 'Warlock') }
  scope :priest, -> { where(which_class: 'Priest') }
  scope :shaman, -> { where(which_class: 'Shaman') }
  scope :druid, -> { where(which_class: 'Druid') }
  scope :healer, -> { where(role: 'Healer') }
  scope :stand_by_healer, -> { where(role: 'Friends and Family-Healer')}
  scope :stand_by_dps, -> { where(role: 'Friends and Family-DPS')}
  scope :not_connected, -> { where(user_id: nil) }

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

  def has_priority_or_has_won_this(item)
    item.winners.each do |winner|
      return true if winner.raider == self
      next
    end
    item.priorities.each do |priority|
      return true if priority.raider == self
      next
    end
    return false
  end

  def low_attendance?
    eight_weeks_ago = Time.now - 57.days # Added a day to account for difference in start of raid and entering of attendance
    attendances_in_last_eight_weeks = self.attendances.where('created_at >= ?', eight_weeks_ago)
    points_earned_last_eight_weeks = attendances_in_last_eight_weeks.sum('points')
    return points_earned_last_eight_weeks < 2.88
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
    'Retired': 'Retired',
    'Friends and Family-DPS': 'Friends and Family-DPS',
    'Friends and Family-Healer': 'Friends and Family-Healer'
  }

  validates :name, presence: true
  validates :which_class, presence: true
  validates :role, presence: true
end

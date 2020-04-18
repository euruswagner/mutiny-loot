class Raid < ApplicationRecord
  has_many :signups, dependent: :destroy

  def zg? 
    name = self.name.downcase.split('')
    if name.include? 'z'
      return true if name.include? 'g'
      return false
    end
    return false
  end
  
  def organized_signups
    tanks = []
    healers = []
    dps_warriors = []
    rogues = []
    ranged = []
    raid_id = self.id
    signups = Signup.where(raid_id: raid_id)
    signups.each do |signup|
      tanks << signup if signup.user.raider.name == 'Ezpzlul' && tanks.count <= 2 && self.zg?
      tanks << signup if signup.user.raider.role == 'Tank' && tanks.count <= 2 && self.zg?
      tanks << signup if signup.user.raider.role == 'Tank'
      healers << signup if signup.user.raider.role == 'Healer' && healers.count <= 5 && self.zg?
      healers << signup if signup.user.raider.role == 'Healer'
      next
    end
    melee = dps_warriors + rogues
    raid = [tanks, healers, melee, ranged]
    return raid
  end

  validates :name, presence: true, length: {minimum: 2, maximum: 25}
  validates :start_time, presence: true
end

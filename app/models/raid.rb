class Raid < ApplicationRecord
  has_many :signups, dependent: :destroy

  def signed_up_tanks
    signed_up_tanks = []
    self.signups.each do |signup|
      signed_up_tanks << signup if signup.user.raider.role == 'Tank'
      next
    end
    return signed_up_tanks
  end

  def signed_up_healers
    priests = []
    shamans = []
    druids = []
    self.signups.each do |signup|
      priests << signup if signup.user.raider.which_class == 'Priest' && signup.user.raider.role == 'Healer' 
      shamans << signup if signup.user.raider.which_class == 'Shaman' && signup.user.raider.role == 'Healer' 
      druids << signup if signup.user.raider.which_class == 'Druid' && signup.user.raider.role == 'Healer' 
      next
    end
    return priests + shamans + druids
  end

  def signed_up_melee
    fury_warriors = []
    rogues = []
    feral_druids = []
    enhancement_shamans = []
    self.signups.each do |signup|
      fury_warriors << signup if signup.user.raider.role == 'Fury'
      rogues << signup if signup.user.raider.which_class == 'Rogue'
      feral_druids << signup if signup.user.raider.role == 'Feral'
      enhancement_shamans << signup if signup.user.raider.role == 'Enhancement'
      next
    end
    return fury_warriors + rogues + feral_druids + enhancement_shamans
  end

  def signed_up_ranged
    hunters = []
    mages = []
    warlocks = []
    shadow_priests = []
    elemental_shamans = []
    moonkin_druids = []
    self.signups.each do |signup|
      hunters << signup if signup.user.raider.which_class == 'Hunter'
      mages << signup if signup.user.raider.which_class == 'Mage'
      warlocks << signup if signup.user.raider.which_class == 'Warlock'
      shadow_priests << signup if signup.user.raider.role == 'Shadow'
      elemental_shamans << signup if signup.user.raider.role == 'Elemental'
      moonkin_druids << signup if signup.user.raider.role == 'Moonkin'
      next
    end
    return hunters + mages + warlocks + shadow_priests + elemental_shamans + moonkin_druids
  end
  
  validates :name, presence: true, length: {minimum: 2}
  validates :start_time, presence: true
end

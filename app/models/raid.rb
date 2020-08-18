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

  def aq? 
    name = self.name.downcase.split('')
    if name.include? 'a'
      return true if name.include? 'q'
      return false
    end
    return false
  end
  
  validates :name, presence: true, length: {minimum: 2, maximum: 25}
  validates :start_time, presence: true
end

class Raider < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :priorities, dependent: :destroy
  has_many :winners, dependent: :destroy

  def weeks_with_the_guild?
    return 0 if self.attendances.first.nil?
    return ((Time.now - self.attendances.first.created_at)/60/60/24/7) + 1.2
  end  
end

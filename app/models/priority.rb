class Priority < ApplicationRecord
  belongs_to :raider
  belongs_to :item
  
  def points_worth
    if ranking >= 48
      return 3.6
    elsif ranking <= 47 && ranking >= 45
      return 2.0
    elsif ranking <= 44 && ranking >= 42
      return 0.8
    else 
      return 0
    end
  end

  validates :ranking, presence: true
end

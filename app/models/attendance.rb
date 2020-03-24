class Attendance < ApplicationRecord
  belongs_to :raider
  
  validates :notes, presence: true, length: {minimum: 3}
  validates :points, presence: true
end

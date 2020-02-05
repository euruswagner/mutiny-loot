class Attendance < ApplicationRecord
  belongs_to :raider
  
  validates :notes, presence: true
end

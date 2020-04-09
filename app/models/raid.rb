class Raid < ApplicationRecord
  has_many :signups, dependent: :destroy
  
  validates :name, presence: true, length: {minimum: 2}
  validates :start_time, presence: true
end

class Raid < ApplicationRecord

  validates :name, presence: true, length: {minimum: 2}
  validates :start_time, presence: true
end

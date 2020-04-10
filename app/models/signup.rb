class Signup < ApplicationRecord
  belongs_to :raid
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:raid_id] }
  validates :notes, length: {maximum: 25}
end

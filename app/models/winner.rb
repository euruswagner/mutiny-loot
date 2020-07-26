class Winner < ApplicationRecord
  belongs_to :raider
  belongs_to :item
  belongs_to :priority, optional: true 
  
  validates :raider_id, uniqueness: { scope: [:priority_id] }
end

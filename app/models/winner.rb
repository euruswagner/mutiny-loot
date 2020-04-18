class Winner < ApplicationRecord
  belongs_to :raider
  belongs_to :item
  
  validates :raider_id, uniqueness: { scope: [:item_id] }
end

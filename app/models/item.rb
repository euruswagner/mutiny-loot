class Item < ApplicationRecord
  belongs_to :category

  has_many :lists, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :priorities, dependent: :destroy

  ZONES = {
    'Blackwing Lair': 'Blackwing Lair',
    'Molten Core': 'Molten Core',
    'Onyxia': 'Onyxia'
  }

end

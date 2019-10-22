class Item < ApplicationRecord
  belongs_to :category
  has_many :comments, dependent: :destroy

  ZONES = {
    'Molten Core': 'Molten Core',
    'Onyxia': 'Onyxia'
  }

end

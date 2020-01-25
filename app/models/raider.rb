class Raider < ApplicationRecord
  has_many :attendances, dependent: :destroy

end
class Raider < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :priorities, dependent: :destroy
  has_many :winners, dependent: :destroy
  
end

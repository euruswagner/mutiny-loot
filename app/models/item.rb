class Item < ApplicationRecord
  belongs_to :category

  has_many :comments, dependent: :destroy
  has_many :priorities, dependent: :destroy
  has_many :winners, dependent: :destroy

  def primary_class?(raider)
    return true if priority.nil?
    primary_class_ary = priority.split()
    primary_class_ary.each do |priority|
      return true if priority == raider.which_class
      return true if priority == raider.role
    end
    return false
  end

  ZONES = {
    'Blackwing Lair': 'Blackwing Lair',
    'Molten Core': 'Molten Core',
    'Onyxia': 'Onyxia'
  }

  CLASSIFICATIONS = {
    'Reserved': 'Reserved',
    'Limited': 'Limited',
    'Unlimited': 'Unlimited'
  }
end

module UsersHelper
  def user_approve_path(u)
      return "/users/approve/#{u.id}"
  end

  def class_color(raider)
    return 'warrior' if raider.which_class == 'Warrior'
    return 'rogue' if raider.which_class == 'Rogue'
    return 'hunter' if raider.which_class == 'Hunter'
    return 'mage' if raider.which_class == 'Mage'
    return 'warlock' if raider.which_class == 'Warlock'
    return 'priest' if raider.which_class == 'Priest'
    return 'shaman' if raider.which_class == 'Shaman'
    return 'druid' if raider.which_class == 'Druid' 
    return ''
  end

  def melee
    melee = []
    @raider.each do |raider|
      if raider.which_class == 'Warrior' || raider.which_class == 'Rogue'
        melee << raider
      elsif raider.role == 'Enhancement' || raider.role == 'Feral'
        melee << raider
      else
        next
      end
    end
    return melee
  end

  def ranged
    ranged = []
    @raider.each do |raider|
      if raider.which_class == 'Hunter' || raider.which_class == 'Mage' || raider.which_class == 'Warlock'
        ranged << raider
      elsif raider.role == 'Shadow' || raider.role == 'Moonkin'
        ranged << raider
      else
        next
      end
    end
    return ranged
  end

  def healer
    healer = []
    @raider.each do |raider|
      if raider.role == 'Healer' 
        healer << raider
      else
        next
      end
    end
    return healer
  end
end

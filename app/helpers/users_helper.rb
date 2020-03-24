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

  def melee_old
    unsorted_melee = []
    @raider.each do |raider|
      next if raider.role == 'Retired'
      if raider.which_class == 'Warrior' || raider.which_class == 'Rogue'
        unsorted_melee << raider
      elsif raider.role == 'Enhancement' || raider.role == 'Feral'
        unsorted_melee << raider
      else
        next
      end
    end
    warrior = []
    rogue = []
    enhancement = []
    feral = []
    unsorted_melee.each do |melee|
      if melee.which_class == 'Warrior'
        warrior << melee
      elsif melee.which_class == 'Rogue'
        rogue << melee
      elsif melee.role == 'Enhancement'
        enhancement << melee
      else
        feral << melee
      end
    end
    sorted_melee = warrior + rogue + enhancement + feral
    return sorted_melee
  end

  def ranged
    unsorted_ranged = []
    @active_raider.each do |raider|
      next if raider.role == 'Retired'
      if raider.which_class == 'Hunter' || raider.which_class == 'Mage' || raider.which_class == 'Warlock'
        unsorted_ranged << raider
      elsif raider.role == 'Shadow' || raider.role == 'Moonkin' || raider.role == 'Elemental'
        unsorted_ranged << raider
      else
        next
      end
    end
    hunter = []
    mage = []
    warlock = []
    shadow = []
    elemental = []
    moonkin = []
    unsorted_ranged.each do |ranged|
      if ranged.which_class == 'Hunter'
        hunter << ranged
      elsif ranged.which_class == 'Mage'
        mage << ranged
      elsif ranged.which_class == 'Warlock'
        warlock << ranged
      elsif ranged.which_class == 'Shadow'
        shadow << ranged
      elsif ranged.role == 'Elemental'
        elemental << ranged
      else
        moonkin << ranged
      end
    end
    sorted_ranged = hunter + mage + warlock + shadow + elemental + moonkin
    return sorted_ranged
  end

  def healer
    unsorted_healer = []
    @active_raider.each do |raider|
      next if raider.role == 'Retired'
      if raider.role == 'Healer' 
        unsorted_healer << raider
      else
        next
      end
    end
    priest = []
    shaman = []
    druid = []
    unsorted_healer.each do |healer|
      if healer.which_class == 'Priest'
        priest << healer
      elsif healer.which_class == 'Shaman'
        shaman << healer
      else
        druid << healer
      end
    end
    sorted_healer = priest + shaman + druid
    return sorted_healer
  end
end

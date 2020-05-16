module RaidersHelper
  def list_is_locked?(raider)
    return raider.priorities.last.locked?
  end

  def priority_rankings
    priority_rankings = []
    33.times do |x|
      ranking = 50 - x
      priority_rankings << ranking
    end
    return priority_rankings
  end

  def aq_priority_rankings
    aq_priority_rankings = []
    26.times do |x|
      ranking = 50 - x
      aq_priority_rankings << ranking
    end
    return aq_priority_rankings
  end

  def bracket(x)
    if x <= 50 && x > 47
      return 'first-bracket'
    elsif x <= 47 && x > 44
      return 'second-bracket'
    elsif x <= 44 && x > 41
      return 'third-bracket'
    else
      return 'no-bracket'
    end    
  end

  def item_classification(priority)
    if priority.item.classification == 'Reserved'
      return 'reserved'
    elsif priority.item.classification =='Limited'
      return 'limited'
    else
      return 'unlimited'
    end
  end 
end

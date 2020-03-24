module RaidersHelper
  def priority_rankings
    priority_rankings = []
    33.times do |x|
      ranking = 50 - x
      priority_rankings << ranking
    end
    return priority_rankings
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

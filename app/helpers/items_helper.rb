module ItemsHelper
  def ordered_list_of_priorities(item)
    ary_of_raiders_with_total_priority = []
    item.priorities.each do |priority|
      next if won_that_item(item, priority)

      points_earned = priority.raider.attendances.sum(:points)
      # points_spent = 
      # total_points = points_earned - points_spent
      ranking = priority.ranking
      adjusted_ranking = ranking + points_earned
      raider = priority.raider.name
      ary_of_raiders_with_total_priority << "#{adjusted_ranking} - #{raider}"
    end
    ary_of_raiders_with_total_priority_sorted = ary_of_raiders_with_total_priority.sort.reverse
    return ary_of_raiders_with_total_priority_sorted
  end

  def won_that_item(item, priority)
    return false if item.winners.empty?
    item.winners.each do |winner|
      if winner.raider_id == priority.raider_id
        return true
      else
        next
      end
    end
    return false
  end

  def raiders_without_priority_assigned(item)
    raiders_without_priority_assigned = []
    @raiders.each do |raider|
      if raider.priorities.empty? then
        raiders_without_priority_assigned << raider
      else
        raider.priorities.each do |priority|
          next if priority.item_id == item.id
          raiders_without_priority_assigned << raider
        end
      end
    end
    return raiders_without_priority_assigned
  end
end

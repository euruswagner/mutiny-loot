module ItemsHelper
  def ordered_list_of_priorities(item)
    ary_of_raiders_with_total_priority = []
    item.priorities.each do |priority|
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

  def random_array
    ary = [1, 2, 3, 4]
    return ary
  end

  def prios_of_fifty(item)
    return item.priorities.where(ranking: 50)
  end
end

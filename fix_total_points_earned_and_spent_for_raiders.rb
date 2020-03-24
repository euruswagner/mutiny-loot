raiders = Raider.all
raiders.each do |raider|
  total_points_earned = raider.attendances.sum('points')
  raider.write_attribute(:total_points_earned, total_points_earned)
  total_points_spent = raider.winners.sum('points_spent')
  raider.write_attribute(:total_points_spent, total_points_spent)
  raider.save
end

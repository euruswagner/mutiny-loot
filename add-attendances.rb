seven_weeks_ago = Time.now - 49.days
Raider.all.each do |raider|
    Attendance.create(raider: raider, notes: 'Bulk Test', points: 4.0, created_at: seven_weeks_ago)
end
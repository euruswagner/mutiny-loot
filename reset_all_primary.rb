Item.all.each do |item|
  item.update(priority: nil)
end
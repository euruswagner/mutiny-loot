require 'rails_helper'

RSpec.describe Priority, type: :model do
  describe 'Priority points_worth method' do
    it 'returns 0 if there is no attendance' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.points_worth).to eq 0
    end

    it 'returns net points if they are worth less then max worth of item' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)
      attendance1 = FactoryBot.create(:attendance, raider: raider, points: 0.2)
      attendance2 = FactoryBot.create(:attendance, raider: raider, points: 0.2)

      expect(priority.points_worth).to eq 0.4
    end

    it 'returns max worth of 3.6 for bracket 1 item' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)
      attendance1 = FactoryBot.create(:attendance, raider: raider, points: 2.0)
      attendance2 = FactoryBot.create(:attendance, raider: raider, points: 2.0)

      expect(priority.points_worth).to eq 3.6
    end
  end

  describe 'Priority total_item_value_for_raider method' do
    it 'returns 0 for raider without attendance' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.total_item_value_for_raider).to eq 0
    end

    it 'returns ranking + net points for full time member' do
      raider = FactoryBot.create(:raider, role: 'Healer')
      item = FactoryBot.create(:item, priority: 'Healer')
      priority = FactoryBot.create(:priority, raider: raider, item: item, ranking: 50)
      five_weeks_ago = Time.now - 35.days
      attendance1 = FactoryBot.create(:attendance, raider: raider, points: 0.4, created_at: five_weeks_ago)
      attendance2 = FactoryBot.create(:attendance, raider: raider, points: 0.4)
      attendance3 = FactoryBot.create(:attendance, raider: raider, points: 0.4)
      attendance4 = FactoryBot.create(:attendance, raider: raider, points: 0.4)
      win1 = FactoryBot.create(:winner, raider: raider, item: item, points_spent: 0.8)
      win2 = FactoryBot.create(:winner, raider: raider, item: item, points_spent: 0.6)


      expect(priority.total_item_value_for_raider).to eq 50.2
    end

    it 'returns half of ranking + net points for non primary spec item' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item, priority: 'Healer')
      priority = FactoryBot.create(:priority, raider: raider, item: item)
      five_weeks_ago = Time.now - 35.days
      attendance1 = FactoryBot.create(:attendance, raider: raider, points: 0.4, created_at: five_weeks_ago)
      attendance2 = FactoryBot.create(:attendance, raider: raider, points: 0.4)
      attendance3 = FactoryBot.create(:attendance, raider: raider, points: 0.4)
      attendance4 = FactoryBot.create(:attendance, raider: raider, points: 0.4)
      win1 = FactoryBot.create(:winner, raider: raider, item: item, points_spent: 0.8)
      win2 = FactoryBot.create(:winner, raider: raider, item: item, points_spent: 0.6)

      expect(priority.total_item_value_for_raider).to eq 25.1
    end

    it 'returns 47.2 if this is 3rd week of raiding for a raider' do
      now = Time.now
      two_weeks_ago = now - 14.days
      raider = FactoryBot.create(:raider)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: two_weeks_ago)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.total_item_value_for_raider).to eq 47.2
    end

    it 'returns 49.2 if this is 3rd week of raiding for a raider and item zone is undefined' do
      now = Time.now
      two_weeks_ago = now - 14.days
      raider = FactoryBot.create(:raider)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: two_weeks_ago)
      item = FactoryBot.create(:item, zone: nil)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.total_item_value_for_raider).to eq 49.2
    end

    it 'returns 49.2 if this is 4th week of raiding for a raider' do
      now = Time.now
      three_weeks_ago = now - 21.days
      raider = FactoryBot.create(:raider)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: three_weeks_ago)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.total_item_value_for_raider).to eq 49.2
    end

    it 'returns 50.2 if this is 5th week of raiding for a raider' do
      now = Time.now
      four_weeks_ago = now - 28.days
      raider = FactoryBot.create(:raider)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: four_weeks_ago)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.total_item_value_for_raider).to eq 50.2
    end
  end  
end

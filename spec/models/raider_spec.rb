require 'rails_helper'

RSpec.describe Raider, type: :model do
  describe 'Raider weeks_with_the_guild? method' do
    it 'returns 0 if there is no attendance' do
      raider = FactoryBot.create(:raider)

      expect(raider.weeks_with_the_guild?).to eq 0
    end

    it 'returns greater than 1.2 if attendance was just created' do
      raider = FactoryBot.create(:raider)
      attendance = FactoryBot.create(:attendance, raider: raider)

      expect(raider.weeks_with_the_guild?).to be > 1.2
      expect(raider.weeks_with_the_guild?).to be < 2.0
    end

    it 'returns greater than 3.2 if attendance was two weeks ago' do
      now = Time.now
      two_weeks_ago = now - 14.days

      raider = FactoryBot.create(:raider)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: two_weeks_ago)

      expect(raider.weeks_with_the_guild?).to be > 3.2
      expect(raider.weeks_with_the_guild?).to be < 4.0
    end
  end

  describe 'Raider points_earned method' do
    it 'returns 0 if no attendances exist' do
      raider = FactoryBot.create(:raider)

      expect(raider.points_earned).to eq 0
    end

    it 'returns 0.4 for two 0.2 attendances' do
      raider = FactoryBot.create(:raider)
      attendance1 = FactoryBot.create(:attendance, raider: raider, points: 0.2)
      attendance2 = FactoryBot.create(:attendance, raider: raider, points: 0.2)

      expect(raider.points_earned).to eq 0.4
    end
  end

  describe 'Raider points_spent method' do
    it 'returns 0 if no winners exist' do
      raider = FactoryBot.create(:raider)

      expect(raider.points_spent).to eq 0
    end

    it 'returns 1.6 for one 1.0 and one 0.6 item won' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      win1 = FactoryBot.create(:winner, raider: raider, item: item, points_spent: 1.0)
      win2 = FactoryBot.create(:winner, raider: raider, item: item, points_spent: 0.6)

      expect(raider.points_spent).to eq 1.6
    end
  end

  describe 'Raider net_points method' do
    it 'returns 0 if there are not attendances or winners' do
      raider = FactoryBot.create(:raider)

      expect(raider.net_points).to eq 0
    end

    it 'returns 0.2 if attendances total 1.6 and winnings total 1.4' do
      raider = FactoryBot.create(:raider)
      attendance1 = FactoryBot.create(:attendance, raider: raider, points: 0.4)
      attendance2 = FactoryBot.create(:attendance, raider: raider, points: 0.4)
      attendance3 = FactoryBot.create(:attendance, raider: raider, points: 0.4)
      attendance4 = FactoryBot.create(:attendance, raider: raider, points: 0.4)
      item = FactoryBot.create(:item)
      win1 = FactoryBot.create(:winner, raider: raider, item: item, points_spent: 0.8)
      win2 = FactoryBot.create(:winner, raider: raider, item: item, points_spent: 0.6)

      expect(raider.net_points).to eq 0.2
    end
  end
end

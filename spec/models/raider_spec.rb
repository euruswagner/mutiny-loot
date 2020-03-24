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

  describe 'Raider net_points method' do
    it 'returns 0 if there are not attendances or winners' do
      raider = FactoryBot.create(:raider)

      expect(raider.net_points).to eq 0
    end

    it 'returns 0.2 if attendances total 1.6 and winnings total 1.4' do
      raider = FactoryBot.create(:raider, total_points_earned: 1.6, total_points_spent: 1.4)

      expect(raider.net_points).to eq 0.2
    end
  end

  describe 'Raider update total points spent' do
    it 'updates raiders total points spent by 1.0' do
      raider = FactoryBot.create(:raider, total_points_spent: 0.6)

      raider.update_total_points_spent(1.0)

      raider.reload
      expect(raider.total_points_spent).to eq 1.6
    end
  end

  describe 'Raider update total points earned' do
    it 'updates raiders total points earned by 1.0' do
      raider = FactoryBot.create(:raider, total_points_earned: 0.6)

      raider.update_total_points_earned(1.0)

      raider.reload
      expect(raider.total_points_earned).to eq 1.6
    end
  end
end

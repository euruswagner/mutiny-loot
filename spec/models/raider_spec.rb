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

  describe 'Raider low_attendance? method' do
    it 'Returns true if Raider has no attendances' do
      raider = FactoryBot.create(:raider)

      expect(raider.low_attendance?).to eq true
    end

    it 'Returns true if Raider has one really old attendance' do
      raider = FactoryBot.create(:raider)
      now = Time.now
      five_weeks_ago = now - 35.days
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: five_weeks_ago)

      expect(raider.low_attendance?).to eq true
    end

    it 'Returns false if Raider has good attendance' do
      raider = FactoryBot.create(:raider)
      now = Time.now
      five_weeks_ago = now - 35.days
      attendance1 = FactoryBot.create(:attendance, raider: raider, created_at: five_weeks_ago)
      attendance2 = FactoryBot.create(:attendance, points: 0.4, raider: raider, created_at: five_weeks_ago)
      attendance3 = FactoryBot.create(:attendance, points: 0.4, raider: raider, created_at: five_weeks_ago)
      attendance4 = FactoryBot.create(:attendance, points: 0.4, raider: raider, created_at: five_weeks_ago)
      attendance5 = FactoryBot.create(:attendance, points: 0.4, raider: raider)
      attendance6 = FactoryBot.create(:attendance, points: 0.4, raider: raider)
      attendance7 = FactoryBot.create(:attendance, points: 0.4, raider: raider)
      attendance8 = FactoryBot.create(:attendance, points: 0.4, raider: raider)

      expect(raider.low_attendance?).to eq false
    end
  end

  describe 'Raider lock_priorities method' do
    it 'locks all priorities for a raider' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      item3 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 5, locked: false)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5, locked: false)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5, locked: false)

      raider.lock_priorities
      priority1.reload
      priority2.reload
      priority3.reload
      expect(priority1.locked).to eq true
      expect(priority2.locked).to eq true
      expect(priority3.locked).to eq true
    end
  end
end

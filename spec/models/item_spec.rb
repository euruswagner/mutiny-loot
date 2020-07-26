require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Item primary_class? method' do
    it 'returns true if there is no priority' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)

      expect(item.primary_class?(raider)).to eq true
    end

    it 'returns true if priority is blank' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item, priority: '')

      expect(item.primary_class?(raider)).to eq true
    end

    it 'returns false if the priority is different' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item, priority: 'Tank')

      expect(item.primary_class?(raider)).to eq false
    end

    it 'returns true if the role matches' do
      raider = FactoryBot.create(:raider, role: 'Tank')
      item = FactoryBot.create(:item, priority: 'Tank')

      expect(item.primary_class?(raider)).to eq true
    end

    it 'returns true if the which_class matches' do
      raider = FactoryBot.create(:raider, which_class: 'Warrior')
      item = FactoryBot.create(:item, priority: 'Warrior')

      expect(item.primary_class?(raider)).to eq true
    end

    it 'returns true if the role matches but not which_class' do
      raider = FactoryBot.create(:raider, which_class: 'Warrior', role: 'Tank')
      item = FactoryBot.create(:item, priority: 'Rogue Tank')

      expect(item.primary_class?(raider)).to eq true
    end
  end

  describe 'Item phase_3_ordered_list_of_priorities method' do
    it 'returns ordered list of priorities without retired raiders' do
      raider1 = FactoryBot.create(:raider, name: 'Raider 1', which_class: 'Warrior', total_points_earned: 4.0, total_points_spent: 3.0)
      raider2 = FactoryBot.create(:raider, name: 'Raider 2', which_class: 'Warrior', total_points_earned: 5.0, total_points_spent: 3.0)
      raider3 = FactoryBot.create(:raider, name: 'Raider 3', which_class: 'Shaman', total_points_earned: 4.0, total_points_spent: 3.0)
      raider4 = FactoryBot.create(:raider, name: 'Raider 4', which_class: 'Shaman', total_points_earned: 4.0, total_points_spent: 3.0)
      raider5 = FactoryBot.create(:raider, name: 'Raider 5', role: 'Retired')
      item = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, item: item, raider: raider1, ranking: 50)
      priority2 = FactoryBot.create(:priority, item: item, raider: raider2, ranking: 50)
      priority3 = FactoryBot.create(:priority, item: item, raider: raider3, ranking: 49)
      priority4 = FactoryBot.create(:priority, item: item, raider: raider4, ranking: 50)
      priority5 = FactoryBot.create(:priority, item: item, raider: raider5, ranking: 50)
      winner = FactoryBot.create(:winner, item: item, raider: raider4)
      five_weeks_ago = Time.now - 35.days
      attendance = FactoryBot.create(:attendance, raider: raider1, points: 0.4, created_at: five_weeks_ago)
      attendance = FactoryBot.create(:attendance, raider: raider2, points: 0.4, created_at: five_weeks_ago)
      attendance = FactoryBot.create(:attendance, raider: raider3, points: 0.4, created_at: five_weeks_ago)
      attendance = FactoryBot.create(:attendance, raider: raider4, points: 0.4, created_at: five_weeks_ago)
      attendance = FactoryBot.create(:attendance, raider: raider5, points: 0.4, created_at: five_weeks_ago)

      expect(item.phase_3_ordered_list_of_priorities).to eq [priority2, priority1, priority3]
    end
  end

  describe 'Item phase_5_ordered_list_of_priorities method' do
    it 'returns list where raider has won first of multiple item occurences but not a second' do
      raider1 = FactoryBot.create(:raider, name: 'Raider 1', which_class: 'Warrior', total_points_earned: 4.0, total_points_spent: 3.0)
      raider2 = FactoryBot.create(:raider, name: 'Raider 2', which_class: 'Warrior', total_points_earned: 5.0, total_points_spent: 3.0)
      raider3 = FactoryBot.create(:raider, name: 'Raider 3', which_class: 'Shaman', total_points_earned: 4.0, total_points_spent: 3.0)
      item = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, item: item, raider: raider1, ranking: 50, phase: 5)
      priority2 = FactoryBot.create(:priority, item: item, raider: raider2, ranking: 50, phase: 5)
      priority3 = FactoryBot.create(:priority, item: item, raider: raider3, ranking: 49, phase: 5)
      priority4 = FactoryBot.create(:priority, item: item, raider: raider1, ranking: 47, phase: 5)
      winner = FactoryBot.create(:winner, item: item, raider: raider1, priority: priority1)
      five_weeks_ago = Time.now - 50.days
      attendance = FactoryBot.create(:attendance, raider: raider1, points: 0.4, created_at: five_weeks_ago)
      attendance = FactoryBot.create(:attendance, raider: raider2, points: 0.4, created_at: five_weeks_ago)
      attendance = FactoryBot.create(:attendance, raider: raider3, points: 0.4, created_at: five_weeks_ago)

      expect(item.phase_5_ordered_list_of_priorities).to eq [priority2, priority3, priority4]
    end
  end

  describe 'Item unlimited? method' do
    it 'returns true if item is unlimited' do
      item = FactoryBot.create(:item, classification: 'Unlimited')

      expect(item.unlimited?).to eq true
    end

    it 'returns false if item is not unlimited' do
      item = FactoryBot.create(:item, classification: 'Limited')

      expect(item.unlimited?).to eq false
    end
  end

  describe 'Item limited? method' do
    it 'returns true if item is limited' do
      item = FactoryBot.create(:item, classification: 'Limited')

      expect(item.limited?).to eq true
    end

    it 'returns false if item is not limited' do
      item = FactoryBot.create(:item, classification: 'Reserved')

      expect(item.limited?).to eq false
    end
  end

  describe 'Item reserved? method' do
    it 'returns true if item is reserved' do
      item = FactoryBot.create(:item, classification: 'Reserved')

      expect(item.reserved?).to eq true
    end

    it 'returns false if item is not reserved' do
      item = FactoryBot.create(:item, classification: 'Limited')

      expect(item.reserved?).to eq false
    end
  end
end

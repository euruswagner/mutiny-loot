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

  describe 'Item raiders_without_priority_assigned method' do
    it 'returns array with all raiders without priority assigned for that item' do
      Raider.destroy_all
      raider1 = FactoryBot.create(:raider, name: 'Raider 1')
      raider2 = FactoryBot.create(:raider, name: 'Raider 2')
      raider3 = FactoryBot.create(:raider, name: 'Raider 3')
      raider4 = FactoryBot.create(:raider, name: 'Raider 4', role: 'Retired')
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, item: item, raider: raider1)

      expect(item.raiders_without_priority_assigned.length).to eq 2
      expect(item.raiders_without_priority_assigned).to eq [raider2, raider3]
      
      raider1.reload
      expect(raider1.name).to eq 'Raider 1'
    end

    it 'returns all raiders if no priorities are assigned' do
      Raider.destroy_all
      raider1 = FactoryBot.create(:raider, name: 'Raider 1')
      raider2 = FactoryBot.create(:raider, name: 'Raider 2')
      raider3 = FactoryBot.create(:raider, name: 'Raider 3')
      item = FactoryBot.create(:item)

      expect(item.raiders_without_priority_assigned.length).to eq 3
      expect(item.raiders_without_priority_assigned).to eq [raider1, raider2, raider3]
    end

    it 'returns an empty array if no raiders exist' do
      Raider.destroy_all
      item = FactoryBot.create(:item)

      expect(item.raiders_without_priority_assigned.length).to eq 0
      expect(item.raiders_without_priority_assigned).to eq []
    end

    it 'returns an empty array if all raiders have priorities' do
      Raider.destroy_all
      raider1 = FactoryBot.create(:raider, name: 'Raider 1')
      raider2 = FactoryBot.create(:raider, name: 'Raider 2')
      raider3 = FactoryBot.create(:raider, name: 'Raider 3')
      raider4 = FactoryBot.create(:raider, name: 'Raider 4', role: 'Retired')
      item = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, item: item, raider: raider1)
      priority2 = FactoryBot.create(:priority, item: item, raider: raider2)
      priority3 = FactoryBot.create(:priority, item: item, raider: raider3)

      expect(item.raiders_without_priority_assigned.length).to eq 0
      expect(item.raiders_without_priority_assigned).to eq []
    end
  end

  describe 'Item warriors_without_priority_assigned method' do
    it 'returns only the warriors that did not have a priority assigned' do
      Raider.destroy_all
      raider1 = FactoryBot.create(:raider, name: 'Raider 1', which_class: 'Warrior')
      raider2 = FactoryBot.create(:raider, name: 'Raider 2', which_class: 'Warrior')
      raider3 = FactoryBot.create(:raider, name: 'Raider 3', which_class: 'Shaman')
      raider4 = FactoryBot.create(:raider, name: 'Raider 4', role: 'Retired')
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, item: item, raider: raider1)

      expect(item.warriors_without_priority_assigned.length).to eq 1
      expect(item.warriors_without_priority_assigned).to eq [raider2]
      
      raider1.reload
      expect(raider1.name).to eq 'Raider 1'
    end
  end

  describe 'Item ordered_list_of_priorities method' do
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

      expect(item.ordered_list_of_priorities).to eq [priority2, priority1, priority3]
    end
  end
end

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
      raider1 = FactoryBot.create(:raider, name: 'Raider 1')
      raider2 = FactoryBot.create(:raider, name: 'Raider 2')
      raider3 = FactoryBot.create(:raider, name: 'Raider 3')
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, item: item, raider: raider1)

      expect(item.raiders_without_priority_assigned.length).to eq 2
      expect(item.raiders_without_priority_assigned).to eq [raider2, raider3]
    end

    it 'returns all raiders if no priorities are assigned' do
      raider1 = FactoryBot.create(:raider, name: 'Raider 1')
      raider2 = FactoryBot.create(:raider, name: 'Raider 2')
      raider3 = FactoryBot.create(:raider, name: 'Raider 3')
      item = FactoryBot.create(:item)

      expect(item.raiders_without_priority_assigned.length).to eq 3
      expect(item.raiders_without_priority_assigned).to eq [raider1, raider2, raider3]
    end

    it 'returns an empty array if no raiders exist' do
      item = FactoryBot.create(:item)

      expect(item.raiders_without_priority_assigned.length).to eq 0
      expect(item.raiders_without_priority_assigned).to eq []
    end

    it 'returns an empty array if all raiders have priorities' do
      raider1 = FactoryBot.create(:raider, name: 'Raider 1')
      raider2 = FactoryBot.create(:raider, name: 'Raider 2')
      raider3 = FactoryBot.create(:raider, name: 'Raider 3')
      item = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, item: item, raider: raider1)
      priority2 = FactoryBot.create(:priority, item: item, raider: raider2)
      priority3 = FactoryBot.create(:priority, item: item, raider: raider3)

      expect(item.raiders_without_priority_assigned.length).to eq 0
      expect(item.raiders_without_priority_assigned).to eq []
    end
  end
end

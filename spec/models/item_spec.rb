require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Item primary_class? method' do
    it 'returns true if there is no priority' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)

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
end

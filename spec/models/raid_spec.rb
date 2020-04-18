require 'rails_helper'

RSpec.describe Raid, type: :model do
  describe 'zg? method' do
    it 'returns true for ZG' do
      raid = FactoryBot.create(:raid, name: 'ZG')

      expect(raid.zg?).to eq true
    end

    it 'returns false for ZAA' do
      raid = FactoryBot.create(:raid, name: 'ZAA')

      expect(raid.zg?).to eq false
    end

    it 'returns false for GAA' do
      raid = FactoryBot.create(:raid, name: 'GAA')

      expect(raid.zg?).to eq false
    end
  end
end

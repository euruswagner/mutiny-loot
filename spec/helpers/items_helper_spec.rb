require 'rails_helper'

RSpec.describe ItemsHelper, type: :helper do
  describe 'raiders_item_value method' do
    it 'returns 0 if raider has no attendance' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(raiders_item_value(item, priority)).to eq 0
    end

    it 'returns 47.2 if this is 3rd week of raiding for a raider' do
      now = Time.now
      two_weeks_ago = now - 14.days
      raider = FactoryBot.create(:raider)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: two_weeks_ago)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(raiders_item_value(item, priority)).to eq 47.2
    end

    it 'returns 49.2 if this is 3rd week of raiding for a raider and item zone is undefined' do
      now = Time.now
      two_weeks_ago = now - 14.days
      raider = FactoryBot.create(:raider)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: two_weeks_ago)
      item = FactoryBot.create(:item, zone: nil)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(raiders_item_value(item, priority)).to eq 49.2
    end

    it 'returns 49.2 if this is 4th week of raiding for a raider' do
      now = Time.now
      three_weeks_ago = now - 21.days
      raider = FactoryBot.create(:raider)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: three_weeks_ago)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(raiders_item_value(item, priority)).to eq 49.2
    end

    it 'returns 50.2 if this is 5th week of raiding for a raider' do
      now = Time.now
      four_weeks_ago = now - 28.days
      raider = FactoryBot.create(:raider)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: four_weeks_ago)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(raiders_item_value(item, priority)).to eq 50.2
    end
  end
end

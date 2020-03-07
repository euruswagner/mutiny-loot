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
end

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the RaidersHelper. For example:
#
# describe RaidersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe RaidersHelper, type: :helper do
  describe 'list_is_locked?(raider) method' do
    it 'returns true if last priority is locked' do
      raider = FactoryBot.create(:raider)
      priority = FactoryBot.create(:priority, raider_id: raider.id, locked: true)

      expect(list_is_locked?(raider)).to eq true
    end

    it 'returns false if last priority is unlocked' do
      raider = FactoryBot.create(:raider)
      priority = FactoryBot.create(:priority, raider_id: raider.id, locked: true)
      priority = FactoryBot.create(:priority, raider_id: raider.id, locked: false)

      expect(list_is_locked?(raider)).to eq false
    end

    it 'returns false if there are no priorities' do
      raider = FactoryBot.create(:raider)

      expect(list_is_locked?(raider)).to eq false
    end
  end
end

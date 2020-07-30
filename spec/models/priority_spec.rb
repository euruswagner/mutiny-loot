require 'rails_helper'

RSpec.describe Priority, type: :model do
  describe 'Priority points_worth method' do
    it 'returns 0 if there is no attendance' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.points_worth).to eq 0
    end

    it 'returns net points if they are worth less then max worth of item' do
      raider = FactoryBot.create(:raider, total_points_earned: 0.4)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.points_worth).to eq 0.4
    end

    it 'returns net points -0.2 if raider is enchanted and has a warlock if raiders has less points than max worth of item' do
      raider = FactoryBot.create(:raider, total_points_earned: 3.7, enchanted: true, warlock: true)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)
      
      expect(priority.points_worth).to eq 3.5
    end

    it 'double check points_worth' do
      raider = FactoryBot.create(:raider, total_points_earned: 2.1, enchanted: true, warlock: true)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item, ranking: 47)
      
      expect(priority.points_worth).to eq 1.9
    end

    it 'triple check points_worth' do
      raider = FactoryBot.create(:raider, total_points_earned: 2.2, enchanted: true, warlock: true)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item, ranking: 47)
      
      expect(priority.points_worth).to eq 2.0
    end

    it 'returns net points -0.1 if raider is enchanted but has no warlock if raiders has less points than max worth of item' do
      raider = FactoryBot.create(:raider, total_points_earned: 0.4, enchanted: true, warlock: false)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.points_worth).to eq 0.3
    end

    it 'returns max worth of 3.6 for bracket 1 item' do
      raider = FactoryBot.create(:raider, total_points_earned: 4.0)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.points_worth).to eq 3.6
    end
  end

  describe 'Priority phase_3_total_item_value_for_raider method' do
    it 'returns 0 for raider without attendance' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.phase_3_total_item_value_for_raider).to eq 0
    end

    it 'returns ranking + net points for full time member' do
      raider = FactoryBot.create(:raider, role: 'Healer', total_points_earned: 1.6, total_points_spent: 1.4)
      item = FactoryBot.create(:item, priority: 'Healer')
      priority = FactoryBot.create(:priority, raider: raider, item: item, ranking: 50)
      five_weeks_ago = Time.now - 35.days
      attendance = FactoryBot.create(:attendance, raider: raider, points: 0.4, created_at: five_weeks_ago)

      expect(priority.phase_3_total_item_value_for_raider).to eq 50.2
    end

    it 'returns half of ranking + net points for non primary spec item' do
      raider = FactoryBot.create(:raider, total_points_earned: 1.6, total_points_spent: 1.4)
      item = FactoryBot.create(:item, priority: 'Healer')
      priority = FactoryBot.create(:priority, raider: raider, item: item)
      five_weeks_ago = Time.now - 35.days
      attendance = FactoryBot.create(:attendance, raider: raider, points: 0.4, created_at: five_weeks_ago)

      expect(priority.phase_3_total_item_value_for_raider).to eq 25.1
    end

    it 'returns 47.2 if this is 3rd week of raiding for a raider' do
      now = Time.now
      two_weeks_ago = now - 14.days
      raider = FactoryBot.create(:raider, total_points_earned: 0.2)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: two_weeks_ago)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.phase_3_total_item_value_for_raider).to eq 47.2
    end

    it 'returns 49.2 if this is 3rd week of raiding for a raider and item zone is undefined' do
      now = Time.now
      two_weeks_ago = now - 14.days
      raider = FactoryBot.create(:raider, total_points_earned: 0.2)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: two_weeks_ago)
      item = FactoryBot.create(:item, zone: nil)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.phase_3_total_item_value_for_raider).to eq 49.2
    end

    it 'returns 49.2 if this is 4th week of raiding for a raider' do
      now = Time.now
      three_weeks_ago = now - 21.days
      raider = FactoryBot.create(:raider, total_points_earned: 0.2)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: three_weeks_ago)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.phase_3_total_item_value_for_raider).to eq 49.2
    end

    it 'returns 50.2 if this is 5th week of raiding for a raider' do
      now = Time.now
      four_weeks_ago = now - 28.days
      raider = FactoryBot.create(:raider, total_points_earned: 0.2)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: four_weeks_ago)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item)

      expect(priority.phase_3_total_item_value_for_raider).to eq 50.2
    end
  end

  describe 'Priority valid_priority? method' do
    it 'returns false if more then two priorities with that ranking' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, category: 'Head')
      item2 = FactoryBot.create(:item, category: 'Legs')
      item3 = FactoryBot.create(:item, category: 'Hands')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5)
      
      expect(priority3.valid_priority?(48)).to eq false
    end

    it 'returns true if there is only one piority with that ranking' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Limited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Limited', category: 'Hands')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 47, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5)
      
      expect(priority3.valid_priority?(48)).to eq true
    end

    it 'returns false if moving a reserved item to non empty row in the brackets' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Reserved', category: 'Hands')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 47, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5)
      
      expect(priority3.valid_priority?(48)).to eq false
    end

    it 'returns true if moving a reserved item to non empty row in the non brackets' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Reserved', category: 'Hands')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 41, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 47, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 48, phase: 5)
      
      expect(priority3.valid_priority?(41)).to eq true
    end

    it 'returns false if a reserved item has that ranking' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Reserved', category: 'Head')
      item2 = FactoryBot.create(:item, category: 'Legs')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 47)
      
      expect(priority2.valid_priority?(48)).to eq false
    end

    it 'returns false if first bracket has 3 allocation points already and item is worth allocation points' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Limited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Limited', category: 'Hands')
      item4 = FactoryBot.create(:item, classification: 'Limited', category: 'Trinket')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 49, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 48, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 47, phase: 5)
      
      expect(priority4.valid_priority?(49)).to eq false
    end

    it 'returns false if first bracket has 2 allocation points already and item is worth allocation points and raider is a hunter' do
      raider = FactoryBot.create(:raider, which_class: 'Hunter')
      item1 = FactoryBot.create(:item, classification: 'Limited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Limited', category: 'Trinket')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 49, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5)
      
      expect(priority3.valid_priority?(49)).to eq false
    end

    it 'returns true if first bracket has 3 allocation points already and item is worth 0 allocation points' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Limited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Limited', category: 'Hands')
      item4 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Trinket')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 49, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 48, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 47, phase: 5)
      
      expect(priority4.valid_priority?(49)).to eq true
    end

    it 'returns true if first bracket has 3 allocation points but item is already in that bracket' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Limited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Limited', category: 'Hands')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 49, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 48, phase: 5)
      
      expect(priority3.valid_priority?(49)).to eq true
    end

    it 'returns false if second bracket has 3 allocation points already and item is worth allocation points' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Limited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Limited', category: 'Hands')
      item4 = FactoryBot.create(:item, classification: 'Limited', category: 'Trinket')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 47, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 46, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 45, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 44, phase: 5)
      
      expect(priority4.valid_priority?(47)).to eq false
    end

    it 'returns true if second bracket has 3 allocation points already and item is worth 0 allocation points' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Limited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Limited', category: 'Hands')
      item4 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Trinket')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 47, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 46, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 45, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 44, phase: 5)
      
      expect(priority4.valid_priority?(47)).to eq true
    end

    it 'returns true if second bracket has 3 allocation points but item is already in that bracket' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Limited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Limited', category: 'Hands')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 47, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 46, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 45, phase: 5)
      
      expect(priority3.valid_priority?(47)).to eq true
    end

    it 'returns false if third bracket has 3 allocation points already and item is worth allocation points' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Limited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Limited', category: 'Hands')
      item4 = FactoryBot.create(:item, classification: 'Limited', category: 'Trinket')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 44, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 43, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 42, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 47, phase: 5)
      
      expect(priority4.valid_priority?(44)).to eq false
    end

    it 'returns true if third bracket has 3 allocation points already and item is worth 0 allocation points' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Limited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Limited', category: 'Hands')
      item4 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Trinket')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 44, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 43, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 42, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 47, phase: 5)
      
      expect(priority4.valid_priority?(44)).to eq true
    end

    it 'returns true if third bracket has 3 allocation points but item is already in that bracket' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Limited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Limited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Limited', category: 'Hands')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 44, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 43, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 42, phase: 5)
      
      expect(priority3.valid_priority?(44)).to eq true
    end

    it 'returns false if ranking is 42 and raider is not primary class for item' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item, classification: 'Limited', priority: 'Hunter', category: 'Trinket')
      priority = FactoryBot.create(:priority, raider: raider, item: item, ranking: 25, phase: 5)

      expect(priority.valid_priority?(42)).to eq false
    end

    it 'returns true if ranking is 41 and raider is not primary class for item' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item, classification: 'Limited', priority: 'Hunter', category: 'Trinket')
      priority = FactoryBot.create(:priority, raider: raider, item: item, ranking: 25, phase: 5)

      expect(priority.valid_priority?(41)).to eq true
    end

    it 'returns false if a category would be represented twice in a bracket' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Head')
      item2 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Hands')
      item4 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Head')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 50, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 50, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 48, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 47, phase: 5)
      
      expect(priority4.valid_priority?(49)).to eq false
    end

    it 'returns true if feet conflict with feet' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Shoulder')
      item2 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Hands')
      item4 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Feet')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 50, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 50, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 48, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 47, phase: 5)
      
      expect(priority4.valid_priority?(49)).to eq true
    end

    it 'returns true if shoulder and feet conflict with Shoulder' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Shoulder')
      item2 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Hands')
      item4 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Shoulder and Feet')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 50, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 50, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 48, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 47, phase: 5)
      
      expect(priority4.valid_priority?(49)).to eq true
    end

    it 'allows multiple Qiraji bindings of command' do
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Shoulder')
      item2 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Hands')
      item4 = FactoryBot.create(:item, name: 'Qiraji Bindings of Command', classification: 'Unlimited', category: 'Shoulder and Feet')
      item5 = FactoryBot.create(:item, name: 'Qiraji Bindings of Command', classification: 'Unlimited', category: 'Shoulder and Feet')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 50, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 50, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 48, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 48, phase: 5)
      priority5 = FactoryBot.create(:priority, raider: raider, item: item5, ranking: 44, phase: 5)
      
      expect(priority5.valid_priority?(49)).to eq true
    end

    it 'returns true if tank moves Eye of Cthun into bracket with ring' do
      raider = FactoryBot.create(:raider, role: 'Tank')
      item1 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Shoulder')
      item2 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Ring')
      item4 = FactoryBot.create(:item, name: 'Eye of C\'Thun', classification: 'Unlimited', category: 'Ring')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 50, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 50, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 48, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 47, phase: 5)
      
      expect(priority4.valid_priority?(49)).to eq true
    end

    it 'returns false if non tank moves Eye of Cthun into bracket with ring' do
      raider = FactoryBot.create(:raider, role: 'DPS')
      item1 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Shoulder')
      item2 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Ring')
      item4 = FactoryBot.create(:item, name: 'Eye of C\'Thun', classification: 'Unlimited', category: 'Ring')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 50, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 50, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 48, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 47, phase: 5)
      
      expect(priority4.valid_priority?(49)).to eq false
    end

    it 'returns false if tank tries to move Cloak into bracket with Eye of Cthun' do
      raider = FactoryBot.create(:raider, role: 'Tank')
      item1 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Shoulder')
      item2 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Legs')
      item3 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Ring')
      item4 = FactoryBot.create(:item, name: 'Eye of C\'Thun', classification: 'Unlimited', category: 'Ring')
      item5 = FactoryBot.create(:item, classification: 'Unlimited', category: 'Back')
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 50, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 50, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 48, phase: 5)
      priority4 = FactoryBot.create(:priority, raider: raider, item: item4, ranking: 48, phase: 5)
      priority5 = FactoryBot.create(:priority, raider: raider, item: item5, ranking: 47, phase: 5)
      
      expect(priority5.valid_priority?(49)).to eq false
    end
  end

  describe 'priority phase_5_total_item_value_for_raider method' do
    it 'returns full for AQ limited item for raider in there sixth week' do
      now = Time.now
      five_weeks_ago = now - 35.days
      raider = FactoryBot.create(:raider, total_points_earned: 0.2)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: five_weeks_ago)
      item = FactoryBot.create(:item, zone: 'Temple of Ahn\'Qiraj', classification: 'Limited')
      priority = FactoryBot.create(:priority, raider: raider, item: item, phase: 5)

      expect(priority.phase_5_total_item_value_for_raider).to eq 150.2
    end
    
    it 'returns -1 for AQ limited item for raider in there fifth week' do
      now = Time.now
      four_weeks_ago = now - 28.days
      raider = FactoryBot.create(:raider, total_points_earned: 0.2)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: four_weeks_ago)
      item = FactoryBot.create(:item, zone: 'Temple of Ahn\'Qiraj', classification: 'Limited')
      priority = FactoryBot.create(:priority, raider: raider, item: item, phase: 5)

      expect(priority.phase_5_total_item_value_for_raider).to eq 149.2
    end

    it 'returns -2 for AQ limited item for raider in there fourth week' do
      now = Time.now
      three_weeks_ago = now - 21.days
      raider = FactoryBot.create(:raider, total_points_earned: 0.2)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: three_weeks_ago)
      item = FactoryBot.create(:item, zone: 'Temple of Ahn\'Qiraj', classification: 'Limited')
      priority = FactoryBot.create(:priority, raider: raider, item: item, phase: 5)

      expect(priority.phase_5_total_item_value_for_raider).to eq 148.2
    end

    it 'returns 0 for AQ limited item for raider in there third week' do
      now = Time.now
      two_weeks_ago = now - 14.days
      raider = FactoryBot.create(:raider, total_points_earned: 0.2)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: two_weeks_ago)
      item = FactoryBot.create(:item, zone: 'Temple of Ahn\'Qiraj', classification: 'Limited')
      priority = FactoryBot.create(:priority, raider: raider, item: item, phase: 5)

      expect(priority.phase_5_total_item_value_for_raider).to eq 0
    end

    it 'returns full value with non primary adjustment for AQ limited item for raider in there sixth week' do
      now = Time.now
      five_weeks_ago = now - 35.days
      raider = FactoryBot.create(:raider, total_points_earned: 0.1)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: five_weeks_ago)
      item = FactoryBot.create(:item, zone: 'Temple of Ahn\'Qiraj', classification: 'Limited', priority: 'Shaman')
      priority = FactoryBot.create(:priority, raider: raider, item: item, phase: 5)

      expect(priority.phase_5_total_item_value_for_raider).to eq 37.58
    end

    it 'allows new raider to have point values for unlimited MC item' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item, zone: 'Molten Core')
      priority = FactoryBot.create(:priority, raider: raider, item: item, phase: 5)

      expect(priority.phase_5_total_item_value_for_raider).to eq 147.0
    end

    it 'does not add 100 for item at ranking 41' do
      now = Time.now
      five_weeks_ago = now - 35.days
      raider = FactoryBot.create(:raider, total_points_earned: 0.1)
      attendance = FactoryBot.create(:attendance, raider: raider, created_at: five_weeks_ago)
      item = FactoryBot.create(:item, zone: 'Temple of Ahn\'Qiraj', classification: 'Limited')
      priority = FactoryBot.create(:priority, raider: raider, item: item, phase: 5, ranking: 41)

      expect(priority.phase_5_total_item_value_for_raider).to eq 41.1
    end
  end
end

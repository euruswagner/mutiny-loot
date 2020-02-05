require 'rails_helper'

RSpec.describe WinnersController, type: :controller do
  describe 'winners#create action' do
    it 'allows winners to be created' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      
      post :create, params: {item_id: item.id, winner: {raider_id: raider.id, points_spent: 3.6}}

      expect(Winner.last.points_spent).to eq 3.6
    end
  end
end

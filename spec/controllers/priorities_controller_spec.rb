require 'rails_helper'

RSpec.describe PrioritiesController, type: :controller do
  describe 'priorities#create action' do
    it 'allows priorities to be created' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      
      post :create, params: {item_id: item.id, priority: {raider_id: raider.id, ranking: 50}}

      expect(Priority.last.ranking).to eq 50
    end
  end
end

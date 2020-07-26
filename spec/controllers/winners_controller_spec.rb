require 'rails_helper'

RSpec.describe WinnersController, type: :controller do
  describe 'winners#create action' do
    it 'allows winners to be created and updates total points spend by a raider' do
      raider = FactoryBot.create(:raider, total_points_spent: 0.6, total_points_earned: 5.0)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, ranking: 50, item_id: item.id, raider_id: raider.id)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin
      
      post :create, params: {item_id: item.id, winner: {raider_id: raider.id, points_spent: 3.6, priority_id: priority.id}}

      expect(response).to redirect_to raider_path(raider)
      winner = Winner.last
      expect(winner.points_spent).to eq 3.6
      expect(winner.priority).to eq priority
      
      raider.reload      
      expect(raider.total_points_spent).to eq 4.2
      expect(raider.total_points_earned).to eq 5.0
    end

    it 'requires user to be signed in' do
      raider = FactoryBot.create(:raider, total_points_spent: 0.6, total_points_earned: 5.0)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, ranking: 50, item_id: item.id, raider_id: raider.id)
      admin = FactoryBot.create(:user, admin: true)
      
      post :create, params: {item_id: item.id, winner: {raider_id: raider.id, points_spent: 3.6, priority_id: priority.id}}

      expect(response).to redirect_to new_user_session_path
      expect(Winner.count).to eq 0

      raider.reload      
      expect(raider.total_points_spent).to eq 0.6
      expect(raider.total_points_earned).to eq 5.0
    end

    it 'requires user to be administrator' do
      raider = FactoryBot.create(:raider, total_points_spent: 0.6, total_points_earned: 5.0)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, ranking: 50, item_id: item.id, raider_id: raider.id)
      non_admin = FactoryBot.create(:user, admin: false)
      sign_in non_admin
      
      post :create, params: {item_id: item.id, winner: {raider_id: raider.id, points_spent: 3.6, priority_id: priority.id}}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(Winner.count).to eq 0

      raider.reload      
      expect(raider.total_points_spent).to eq 0.6
      expect(raider.total_points_earned).to eq 5.0
    end

    it 'allows raider to win same item twice' do
      raider = FactoryBot.create(:raider, total_points_spent: 0.6, total_points_earned: 5.0)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, ranking: 50, item_id: item.id, raider_id: raider.id)
      winner = FactoryBot.create(:winner, raider_id: raider.id, item_id: item.id, points_spent: 3.6)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin
      
      post :create, params: {item_id: item.id, winner: {raider_id: raider.id, points_spent: 3.6, priority_id: priority.id}}

      expect(response).to redirect_to raider_path(raider)
      winner = Winner.last
      expect(winner.points_spent).to eq 3.6
      expect(winner.priority).to eq priority
      
      raider.reload      
      expect(raider.total_points_spent).to eq 4.2
      expect(raider.total_points_earned).to eq 5.0
    end

    it 'does not allow raider to win on the same priority' do
      raider = FactoryBot.create(:raider, total_points_spent: 3.6, total_points_earned: 5.0)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, ranking: 50, item_id: item.id, raider_id: raider.id)
      winner = FactoryBot.create(:winner, raider_id: raider.id, item_id: item.id, points_spent: 3.6, priority_id: priority.id)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin
      
      post :create, params: {item_id: item.id, winner: {raider_id: raider.id, points_spent: 3.6, priority_id: priority.id}}

      expect(response).to redirect_to item_path(item)
      expect(flash[:alert]).to eq 'There was an error creating this.'
      
      expect(Winner.count).to eq 1
      
      raider.reload      
      expect(raider.total_points_spent).to eq 3.6
      expect(raider.total_points_earned).to eq 5.0
    end
  end

  describe 'winners#destroy action' do
    it 'allows winners to be destroyed and updates total points spent by a raider' do
      raider = FactoryBot.create(:raider, total_points_spent: 4.6, total_points_earned: 5.0)
      item = FactoryBot.create(:item)
      winner = FactoryBot.create(:winner, raider: raider, item: item, points_spent: 3.6)
      user = FactoryBot.create(:user, admin: true)
      sign_in user
      
      delete :destroy, params: {use_route: "item/#{item.id}/winners/", id: winner.id, item_id: item.id}

      expect(response).to redirect_to item_path(item)
      expect(Winner.count).to eq 0
      
      raider.reload      
      expect(raider.total_points_spent).to eq 1.0
      expect(raider.total_points_earned).to eq 5.0
    end

    it 'requires user to be signed in' do
      raider = FactoryBot.create(:raider, total_points_spent: 4.6, total_points_earned: 5.0)
      item = FactoryBot.create(:item)
      winner = FactoryBot.create(:winner, raider: raider, item: item, points_spent: 3.6)
      user = FactoryBot.create(:user, admin: true)
      
      delete :destroy, params: {use_route: "item/#{item.id}/winners/", winner_id: winner.id, item_id: item.id}

      expect(response).to redirect_to new_user_session_path
      expect(Winner.count).to eq 1

      raider.reload      
      expect(raider.total_points_spent).to eq 4.6
      expect(raider.total_points_earned).to eq 5.0
    end

    it 'requires user to be administrator' do
      raider = FactoryBot.create(:raider, total_points_spent: 4.6, total_points_earned: 5.0)
      item = FactoryBot.create(:item)
      winner = FactoryBot.create(:winner, raider: raider, item: item, points_spent: 3.6)
      user = FactoryBot.create(:user)
      sign_in user
      
      delete :destroy, params: {use_route: "item/#{item.id}/winners/", winner_id: winner.id, item_id: item.id}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(Winner.count).to eq 1

      raider.reload      
      expect(raider.total_points_spent).to eq 4.6
      expect(raider.total_points_earned).to eq 5.0
    end
  end
end

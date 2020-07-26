require 'rails_helper'

RSpec.describe RaidersController, type: :controller do
  describe 'raiders#create action' do
    it 'allows raiders to be created' do
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      post :create, params: {raider: {name: 'Test', which_class: 'Shaman', role: 'Elemental'}}

      last_raider = Raider.last
      expect(last_raider.name).to eq 'Test'
      expect(last_raider.which_class).to eq 'Shaman'
      expect(last_raider.role).to eq 'Elemental'
    end

    it 'requires users to be signed in' do
      Raider.destroy_all
      user = FactoryBot.create(:user, admin: true)

      post :create, params: {raider: {name: 'Test', which_class: 'Shaman', role: 'Elemental'}}

      expect(response).to redirect_to new_user_session_path
      expect(Raider.count).to eq 0
    end

    it 'does not allow non admins to create raiders' do
      Raider.destroy_all
      user = FactoryBot.create(:user, admin: false)
      sign_in user
      
      post :create, params: {raider: {name: 'Test2', which_class: 'Shaman', role: 'Elemental'}}
      
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(Raider.count).to eq 0
    end
  end

  describe 'raiders#update action' do
    it 'allows raiders to be updated' do
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      patch :update, params: {id: raider.id, raider: {role: 'Tank'}}

      expect(response).to redirect_to raider_path(raider)
      raider.reload
      expect(raider.role).to eq "Tank"
    end

    it 'requires users to be signed in' do
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, admin: true)

      patch :update, params: {id: raider.id, raider: {role: 'Tank'}}

      expect(response).to redirect_to new_user_session_path
      
      raider.reload
      expect(raider.role).to eq 'Fury'
    end

    it 'does not allow non admins to update raiders' do
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, admin: false)
      sign_in user

      patch :update, params: {id: raider.id, raider: {role: 'Tank'}}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'

      raider.reload
      expect(raider.role).to eq 'Fury'
    end
  end

  describe 'raiders#enchanted action' do
    it 'updates a non enchanted raider to true and grants 0.1 points earned' do
      raider = FactoryBot.create(:raider, enchanted: false, total_points_earned: 0.4)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin

      get :enchanted, params: {use_route: "raiders/#{raider.id}/enchanted", raider_id: raider.id}

      expect(response).to redirect_to raider_path(raider)

      raider.reload
      expect(raider.enchanted).to eq true
      expect(raider.total_points_earned).to eq 0.5
    end

    it 'updates an enchanted raider to false and removes 0.1 points earned' do
      raider = FactoryBot.create(:raider, enchanted: true, total_points_earned: 0.4)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin

      get :enchanted, params: {use_route: "raiders/#{raider.id}/enchanted", raider_id: raider.id}

      expect(response).to redirect_to raider_path(raider)

      raider.reload
      expect(raider.enchanted).to eq false
      expect(raider.total_points_earned).to eq 0.3
    end

    it 'requires user to be signed in to perform' do
      raider = FactoryBot.create(:raider, enchanted: false, total_points_earned: 0.4)
      admin = FactoryBot.create(:user, admin: true)

      get :enchanted, params: {use_route: "raiders/#{raider.id}/enchanted", raider_id: raider.id}

      expect(response).to redirect_to new_user_session_path

      raider.reload
      expect(raider.enchanted).to eq false
      expect(raider.total_points_earned).to eq 0.4
    end

    it 'requires that user be an admin to perform' do
      raider = FactoryBot.create(:raider, enchanted: false, total_points_earned: 0.4)
      non_admin = FactoryBot.create(:user, admin: false)
      sign_in non_admin

      get :enchanted, params: {use_route: "raiders/#{raider.id}/enchanted", raider_id: raider.id}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'

      raider.reload
      expect(raider.enchanted).to eq false
      expect(raider.total_points_earned).to eq 0.4
    end
  end

  describe 'raiders#warlock action' do
    it 'updates a raider without a warlock and adds points' do
      raider = FactoryBot.create(:raider, warlock: false, total_points_earned: 0.4)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin

      get :warlock, params: {use_route: "raiders/#{raider.id}/warlock", raider_id: raider.id}

      expect(response).to redirect_to raider_path(raider)

      raider.reload
      expect(raider.warlock).to eq true
      expect(raider.total_points_earned).to eq 0.5
    end

    it 'updates a raider with a warlock and subtracts points' do
      raider = FactoryBot.create(:raider, warlock: true, total_points_earned: 0.4)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin

      get :warlock, params: {use_route: "raiders/#{raider.id}/warlock", raider_id: raider.id}

      expect(response).to redirect_to raider_path(raider)

      raider.reload
      expect(raider.warlock).to eq false
      expect(raider.total_points_earned).to eq 0.3
    end

    it 'requires user to be signed in to perform action' do
      raider = FactoryBot.create(:raider, warlock: false, total_points_earned: 0.4)
      admin = FactoryBot.create(:user, admin: true)

      get :warlock, params: {use_route: "raiders/#{raider.id}/warlock", raider_id: raider.id}

      expect(response).to redirect_to new_user_session_path

      raider.reload
      expect(raider.warlock).to eq false
      expect(raider.total_points_earned).to eq 0.4
    end

    it 'requires user to be admin to perform action' do
      raider = FactoryBot.create(:raider, warlock: false, total_points_earned: 0.4)
      non_admin = FactoryBot.create(:user, admin: false)
      sign_in non_admin

      get :warlock, params: {use_route: "raiders/#{raider.id}/warlock", raider_id: raider.id}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'

      raider.reload
      expect(raider.warlock).to eq false
      expect(raider.total_points_earned).to eq 0.4
    end
  end
end

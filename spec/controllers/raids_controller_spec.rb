require 'rails_helper'

RSpec.describe RaidsController, type: :controller do
  describe 'raid#create action' do
    it 'it creates new raids' do
      time = 'April 15th, 2020 8:00PM'
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      post :create, params: {raid: {name: 'ZG', start_time: time}}

      last_raid = Raid.last
      expect(response).to redirect_to calendar_path
      expect(last_raid.name).to eq 'ZG'
      expect(last_raid.start_time.day).to eq 15
      expect(last_raid.start_time.month).to eq 4
    end

    it 'requires valid name' do
      time = 'April 15th, 2020 8:00PM'
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      post :create, params: {raid: {name: 'Z', start_time: time}}

      expect(response).to redirect_to calendar_path
      expect(flash[:alert]).to eq 'The information you have entered is incomplete.'
      expect(Raid.count).to eq 0
    end

    it 'requires valid time' do
      time = ''
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      post :create, params: {raid: {name: 'ZG', start_time: time}}

      expect(response).to redirect_to calendar_path
      expect(flash[:alert]).to eq 'The information you have entered is incomplete.'
      expect(Raid.count).to eq 0
    end

    it 'requires user to be logged in' do
      time = 'April 15th, 2020 8:00PM'
      user = FactoryBot.create(:user, admin: true)

      post :create, params: {raid: {name: 'ZG', start_time: time}}

      expect(response).to redirect_to new_user_session_path
      expect(Raid.count).to eq 0
    end

    it 'requires user to be an admin' do
      time = 'April 15th, 2020 8:00PM'
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: {raid: {name: 'ZG', start_time: time}}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(Raid.count).to eq 0
    end
  end

  describe 'raids#update action' do
    it 'allows raids to be updated' do
      raid = FactoryBot.create(:raid)
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      patch :update, params: {id: raid.id, raid: {name: 'BWL'}}

      expect(response).to redirect_to raid_path(raid)
      raid.reload
      expect(raid.name).to eq 'BWL'
    end

    it 'requires users to be logged in' do
      raid = FactoryBot.create(:raid)
      user = FactoryBot.create(:user, admin: true)

      patch :update, params: {id: raid.id, raid: {name: 'BWL'}}

      expect(response).to redirect_to new_user_session_path
      expect(raid.name).to eq 'ZG'
    end

    it 'requires users to be admins to update' do
      raid = FactoryBot.create(:raid)
      user = FactoryBot.create(:user)
      sign_in user

      patch :update, params: {id: raid.id, raid: {name: 'BWL'}}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(raid.name).to eq 'ZG'
    end
  end

  describe 'raids#destroy action' do
    it 'allows raids to be destroyed' do
      raid = FactoryBot.create(:raid)
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      delete :destroy, params: {id: raid.id}

      expect(response).to redirect_to calendar_path
      expect(flash[:notice]).to eq 'You have successfully deleted a raid.'
      expect(Raid.count).to eq 0
    end

    it 'requires users to be signed in' do
      raid = FactoryBot.create(:raid)
      user = FactoryBot.create(:user, admin: true)

      delete :destroy, params: {id: raid.id}

      expect(response).to redirect_to new_user_session_path
      expect(raid.name).to eq 'ZG'
    end

    it 'requires users to be admins to delete' do
      raid = FactoryBot.create(:raid)
      user = FactoryBot.create(:user)
      sign_in user

      delete :destroy, params: {id: raid.id}
      
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(raid.name).to eq 'ZG'
    end
  end

  describe 'raids#show action' do
    it 'it organizes the raid' do
      raid = FactoryBot.create(:raid, name: 'BWL')
      raider = FactoryBot.create(:raider, which_class: 'Warrior', role: 'Fury')
      user = FactoryBot.create(:user, raider_id: raider.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user.id)
      
      get :show, params: { id: raid.id}
      
      expect(response).to have_http_status(:success)
      expect(assigns(:raid)).to eq(raid)
      expect(assigns(:organized_signups)[2].count).to eq 1
    end

    it 'In ZG 3rd tank becomes DPS 6th healer becomes standby' do
      raid = FactoryBot.create(:raid, name: 'ZG - optionalz')
      raider1 = FactoryBot.create(:raider, which_class: 'Warrior', role: 'Tank')
      raider2 = FactoryBot.create(:raider, which_class: 'Warrior', role: 'Tank')
      raider3 = FactoryBot.create(:raider, which_class: 'Warrior', role: 'Tank')
      raider4 = FactoryBot.create(:raider, which_class: 'Shaman', role: 'Healer')
      raider5 = FactoryBot.create(:raider, which_class: 'Shaman', role: 'Healer')
      raider6 = FactoryBot.create(:raider, which_class: 'Shaman', role: 'Healer')
      raider7 = FactoryBot.create(:raider, which_class: 'Priest', role: 'Healer')
      raider8 = FactoryBot.create(:raider, which_class: 'Priest', role: 'Healer')
      raider9 = FactoryBot.create(:raider, which_class: 'Druid', role: 'Healer')
      user1 = FactoryBot.create(:user, raider_id: raider1.id)
      user2 = FactoryBot.create(:user, raider_id: raider2.id)
      user3 = FactoryBot.create(:user, raider_id: raider3.id)
      user4 = FactoryBot.create(:user, raider_id: raider4.id)
      user5 = FactoryBot.create(:user, raider_id: raider5.id)
      user6 = FactoryBot.create(:user, raider_id: raider6.id)
      user7 = FactoryBot.create(:user, raider_id: raider7.id)
      user8 = FactoryBot.create(:user, raider_id: raider8.id)
      user9 = FactoryBot.create(:user, raider_id: raider9.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user1.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user2.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user3.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user4.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user5.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user6.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user7.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user8.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user9.id)
      
      get :show, params: { id: raid.id}
      
      expect(response).to have_http_status(:success)
      expect(assigns(:raid)).to eq(raid)
      expect(assigns(:organized_signups)[0].count).to eq 2
      expect(assigns(:organized_signups)[2].count).to eq 1
      expect(assigns(:organized_signups)[1].count).to eq 5
      expect(assigns(:organized_signups)[4].count).to eq 1
    end

    it 'In non ZG no limits to assignments' do
      raid = FactoryBot.create(:raid, name: 'Another go')
      raider1 = FactoryBot.create(:raider, which_class: 'Warrior', role: 'Tank')
      raider2 = FactoryBot.create(:raider, which_class: 'Warrior', role: 'Tank')
      raider3 = FactoryBot.create(:raider, which_class: 'Warrior', role: 'Tank')
      raider4 = FactoryBot.create(:raider, which_class: 'Shaman', role: 'Healer')
      raider5 = FactoryBot.create(:raider, which_class: 'Shaman', role: 'Healer')
      raider6 = FactoryBot.create(:raider, which_class: 'Shaman', role: 'Healer')
      raider7 = FactoryBot.create(:raider, which_class: 'Priest', role: 'Healer')
      raider8 = FactoryBot.create(:raider, which_class: 'Priest', role: 'Healer')
      raider9 = FactoryBot.create(:raider, which_class: 'Druid', role: 'Healer')
      user1 = FactoryBot.create(:user, raider_id: raider1.id)
      user2 = FactoryBot.create(:user, raider_id: raider2.id)
      user3 = FactoryBot.create(:user, raider_id: raider3.id)
      user4 = FactoryBot.create(:user, raider_id: raider4.id)
      user5 = FactoryBot.create(:user, raider_id: raider5.id)
      user6 = FactoryBot.create(:user, raider_id: raider6.id)
      user7 = FactoryBot.create(:user, raider_id: raider7.id)
      user8 = FactoryBot.create(:user, raider_id: raider8.id)
      user9 = FactoryBot.create(:user, raider_id: raider9.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user1.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user2.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user3.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user4.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user5.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user6.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user7.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user8.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user9.id)
      
      get :show, params: { id: raid.id}
      
      expect(response).to have_http_status(:success)
      expect(assigns(:raid)).to eq(raid)
      expect(assigns(:organized_signups)[0].count).to eq 3
      expect(assigns(:organized_signups)[2].count).to eq 0
      expect(assigns(:organized_signups)[1].count).to eq 6
      expect(assigns(:organized_signups)[4].count).to eq 0
    end
  end
end

require 'rails_helper'

RSpec.describe RaidsController, type: :controller do
  describe 'raid#create action' do
    it 'it creates new raids' do
      time = 'April 15th, 2020 8:00PM'
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      post :create, params: {raid: {name: 'ZG', start_time: time}}

      last_raid = Raid.last
      expect(response).to redirect_to raid_path(last_raid)
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
end

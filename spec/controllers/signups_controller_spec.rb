require 'rails_helper'

RSpec.describe SignupsController, type: :controller do
  describe 'signups#create action' do
    it 'allows signups to be created' do
      raid = FactoryBot.create(:raid)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)
      sign_in user

      post :create, params: {raid_id: raid.id}
      
      expect(response).to redirect_to raid_path(raid)
      last_signup = Signup.last
      raider_id = last_signup.user.raider_id 
      expect(last_signup.user_id).to eq user.id
      expect(Raider.find(raider_id).role).to eq 'Fury'
    end

    it 'reguires users to be logged in to create signups' do
      raid = FactoryBot.create(:raid)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)

      post :create, params: {raid_id: raid.id}
      
      expect(response).to redirect_to new_user_session_path
      expect(Signup.count).to eq 0
    end
  end
end

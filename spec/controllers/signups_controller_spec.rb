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
      expect(flash[:notice]).to eq 'You have signed up for this raid see you then.'
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

    it 'does not allow double signups' do
      raid = FactoryBot.create(:raid)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user.id)
      sign_in user

      post :create, params: {raid_id: raid.id}
      
      expect(response).to redirect_to raid_path(raid)
      expect(flash[:alert]).to eq 'You have already signed up for this raid.'
      expect(Signup.count).to eq 1
    end

    it 'does not allow signups before a week' do
      start_time_two_weeks_ahead = Time.now + 14.days
      open_time = Time.now + 7.days - 4.hours # subtracting 4 hours since controller uses Eastern Zone and Rspec uses UTC
      raid = FactoryBot.create(:raid, start_time: start_time_two_weeks_ahead)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)
      sign_in user

      post :create, params: {raid_id: raid.id}
      
      expect(response).to redirect_to raid_path(raid)
      expect(flash[:alert]).to eq "You can not currently sign up for this raid. Signups open #{open_time.strftime("%B %-d, %Y %l:%M %p")}"
      expect(Signup.count).to eq 0
    end

    it 'does not allow signups after raid start time' do
      start_time_one_minute_ago = Time.now - 1.minute
      raid = FactoryBot.create(:raid, start_time: start_time_one_minute_ago)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)
      sign_in user

      post :create, params: {raid_id: raid.id}
      
      expect(response).to redirect_to raid_path(raid)
      expect(flash[:alert]).to eq 'You can not sign up for raids that have already occured.'
      expect(Signup.count).to eq 0
    end
  end
end

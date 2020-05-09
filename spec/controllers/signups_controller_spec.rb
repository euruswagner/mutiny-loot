require 'rails_helper'

RSpec.describe SignupsController, type: :controller do
  describe 'signups#create action' do
    it 'allows signups to be created' do
      raid = FactoryBot.create(:raid)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)
      sign_in user

      post :create, params: {raid_id: raid.id, signup: {notes: 'Test'}}
      
      expect(response).to redirect_to raid_path(raid)
      expect(flash[:notice]).to eq 'You have signed up for this raid see you then.'
      last_signup = Signup.last
      raider_id = last_signup.user.raider_id 
      expect(last_signup.user_id).to eq user.id
      expect(last_signup.notes).to eq 'Test'
      expect(Raider.find(raider_id).role).to eq 'Fury'
    end

    it 'reguires users to be logged in to create signups' do
      raid = FactoryBot.create(:raid)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)

      post :create, params: {raid_id: raid.id, signup: {notes: 'Test'}}
      
      expect(response).to redirect_to new_user_session_path
      expect(Signup.count).to eq 0
    end

    it 'reguires users to have connected raider' do
      raid = FactoryBot.create(:raid)
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: {raid_id: raid.id, signup: {notes: 'Test'}}
      
      expect(response).to redirect_to raid_path(raid)
      expect(flash[:alert]).to eq 'You do not have a connected raider. Please contact an officer to correct this.'
      expect(Signup.count).to eq 0
    end

    it 'does not allow double signups' do
      raid = FactoryBot.create(:raid)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user.id)
      sign_in user

      post :create, params: {raid_id: raid.id, signup: {notes: 'Test'}}
      
      expect(response).to redirect_to raid_path(raid)
      expect(flash[:alert]).to eq 'You have either already signed up for this raid or your note is to long.'
      expect(Signup.count).to eq 1
    end

    it 'does not allow notes over 25 characters' do
      raid = FactoryBot.create(:raid)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)
      sign_in user

      post :create, params: {raid_id: raid.id, signup: {notes: '12345678901234567890123 45'}}
      
      expect(response).to redirect_to raid_path(raid)
      expect(flash[:alert]).to eq 'You have either already signed up for this raid or your note is to long.'
      expect(Signup.count).to eq 0
    end

    it 'does not allow signups before a week' do
      start_time_two_weeks_ahead = Time.now + 14.days
      open_time = Time.now + 7.days - 4.hours # subtracting 4 hours since controller uses Eastern Zone and Rspec uses UTC
      raid = FactoryBot.create(:raid, start_time: start_time_two_weeks_ahead)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)
      sign_in user

      post :create, params: {raid_id: raid.id, signup: {notes: 'Test'}}
      
      expect(response).to redirect_to raid_path(raid)
      expect(flash[:alert]).to eq "You can not currently sign up for this raid. Sign ups open #{open_time.strftime("%B %-d, %Y %l:%M %p")} EST."
      expect(Signup.count).to eq 0
    end

    it 'does not allow signups after raid start time' do
      start_time_one_minute_ago = Time.now - 1.minute
      raid = FactoryBot.create(:raid, start_time: start_time_one_minute_ago)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)
      sign_in user

      post :create, params: {raid_id: raid.id, signup: {notes: 'Test'}}
      
      expect(response).to redirect_to raid_path(raid)
      expect(flash[:alert]).to eq 'You can not sign up for raids that have already occured.'
      expect(Signup.count).to eq 0
    end
  end

  describe 'signups#destroy action' do
    it 'allows a sign up to be destoyed' do
      raid = FactoryBot.create(:raid)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user.id)
      sign_in user

      delete :destroy, params: {use_route: "raids/#{raid.id}/signups/", id: signup.id, raid_id: raid.id}

      expect(response).to redirect_to raid_path(raid)
      expect(flash[:notice]).to eq 'You have eliminated your sign up for this raid.'
      expect(Signup.count).to eq 0
    end

    it 'requires user to be signed in' do
      raid = FactoryBot.create(:raid)
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user, raider_id: raider.id)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user.id)

      delete :destroy, params: {use_route: "raids/#{raid.id}/signups/", id: signup.id, raid_id: raid.id}

      expect(response).to redirect_to new_user_session_path
      expect(Signup.count).to eq 1
    end

    it 'requires correct user to be signed in' do
      raid = FactoryBot.create(:raid)
      raider = FactoryBot.create(:raider)
      user1 = FactoryBot.create(:user, raider_id: raider.id)
      user2 = FactoryBot.create(:user)
      signup = FactoryBot.create(:signup, raid_id: raid.id, user_id: user1.id)
      sign_in user2

      delete :destroy, params: {use_route: "raids/#{raid.id}/signups/", id: signup.id, raid_id: raid.id}

      expect(response).to redirect_to raid_path(raid)
      expect(flash[:alert]).to eq 'This is not your raid sign up.'
      expect(Signup.count).to eq 1
    end
  end
end

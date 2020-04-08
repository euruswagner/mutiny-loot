require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'Users#connect action' do
    it 'allows users to be connected to raiders' do
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin

      get :connect, params: {user_id: user, raider_id: raider}

      expect(response).to redirect_to user_path(admin)
      user.reload
      raider.reload
           
      expect(user.raider).to eq raider
      expect(user.raider.role).to eq 'Fury'
      expect(raider.user).to eq user
    end

    it 'requires user to be signed in to connect' do
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user)
      admin = FactoryBot.create(:user, admin: true)

      get :connect, params: {user_id: user, raider_id: raider}

      expect(response).to redirect_to new_user_session_path
      user.reload
      raider.reload
           
      expect(user.raider).to eq nil
      expect(raider.user).to eq nil
    end

    it 'does not allow non admins to connect raiders and users' do
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user)
      sign_in user

      get :connect, params: {user_id: user, raider_id: raider}

      expect(response).to redirect_to root_path
      user.reload
      raider.reload
           
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(user.raider).to eq nil
      expect(raider.user).to eq nil
    end
  end
end
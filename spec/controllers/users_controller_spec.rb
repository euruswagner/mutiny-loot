require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'Users#approve action' do
    it 'allows users to be approved' do
      user = FactoryBot.create(:user, approved: false)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin

      get :approve, params: {id: user}

      expect(response).to redirect_to user_index_path
      user.reload

      expect(user.approved).to eq true
    end

    it 'requires users to be signed in to approve' do
      user = FactoryBot.create(:user, approved: false)
      admin = FactoryBot.create(:user, admin: true)

      get :approve, params: {id: user}

      expect(response).to redirect_to new_user_session_path
      user.reload

      expect(user.approved).to eq false
    end

    it 'requires user to be admin to approve' do
      user = FactoryBot.create(:user, approved: false)
      non_admin = FactoryBot.create(:user, admin: false)
      sign_in non_admin

      get :approve, params: {id: user}

      expect(response).to redirect_to root_path
      user.reload
           
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(user.approved).to eq false
    end
  end

  describe 'Users#unapprove action' do
    it 'allows admins to unapprove users' do
      user = FactoryBot.create(:user)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin

      get :unapprove, params: {id: user}

      expect(response).to redirect_to user_index_path

      user.reload
      expect(user.approved).to eq false
    end

    it 'requires users to be signed in to unapprove users' do
      user = FactoryBot.create(:user)
      admin = FactoryBot.create(:user, admin: true)

      get :unapprove, params: {id: user}

      expect(response).to redirect_to new_user_session_path

      user.reload
      expect(user.approved).to eq true
    end

    it 'only admins can unapprove users' do
      user = FactoryBot.create(:user)
      non_admin = FactoryBot.create(:user, admin: false)
      sign_in non_admin

      get :unapprove, params: {id: user}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      user.reload
      expect(user.approved).to eq true
    end
  end

  describe 'Users#raider action' do
    it 'allows admins to promote users to raiders' do
      user = FactoryBot.create(:user)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin

      get :raider, params: {id: user}

      expect(response).to redirect_to user_index_path
      user.reload

      expect(user.approved_raider).to eq true
    end

    it 'requires users to be signed in to promote to raiders' do
      user = FactoryBot.create(:user)
      admin = FactoryBot.create(:user, admin: true)

      get :raider, params: {id: user}

      expect(response).to redirect_to new_user_session_path
      user.reload

      expect(user.approved_raider).to eq false
    end

    it 'requires user to be admin to promote to raider' do
      user = FactoryBot.create(:user)
      non_admin = FactoryBot.create(:user, admin: false)
      sign_in non_admin

      get :raider, params: {id: user}

      expect(response).to redirect_to root_path
      user.reload
           
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(user.approved_raider).to eq false
    end
  end

  describe 'Users#demote action' do
    it 'allows admins to demote raiders' do
      user = FactoryBot.create(:user, approved_raider: true)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin

      get :demote, params: {id: user}

      expect(response).to redirect_to user_index_path

      user.reload
      expect(user.approved_raider).to eq false
    end

    it 'users must be signed in to demote raiders' do
      user = FactoryBot.create(:user, approved_raider: true)
      admin = FactoryBot.create(:user, admin: true)

      get :demote, params: {id: user}

      expect(response).to redirect_to new_user_session_path

      user.reload
      expect(user.approved_raider).to eq true
    end

    it 'only admins can demote raiders' do
      user = FactoryBot.create(:user, approved_raider: true)
      non_admin = FactoryBot.create(:user, admin: false)
      sign_in non_admin

      get :demote, params: {id: user}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'

      user.reload
      expect(user.approved_raider).to eq true
    end
  end

  describe 'Users#admin action' do
    it 'allows admins to promote other admins' do
      user = FactoryBot.create(:user)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin

      get :admin, params: {id: user}

      expect(response).to redirect_to user_index_path

      user.reload
      expect(user.admin).to eq true
    end

    it 'requires users to be signed in to promote other admins' do
      user = FactoryBot.create(:user)
      admin = FactoryBot.create(:user, admin: true)

      get :admin, params: {id: user}

      expect(response).to redirect_to new_user_session_path

      user.reload
      expect(user.admin).to eq false
    end

    it 'only admins can promote other admins' do
      user = FactoryBot.create(:user)
      non_admin = FactoryBot.create(:user, admin: false)
      sign_in non_admin

      get :admin, params: {id: user}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'

      user.reload
      expect(user.admin).to eq false
    end
  end

  describe 'users#demote_admin action' do
    it 'allows other admins to demote an admin' do
      user = FactoryBot.create(:user, admin: true)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin

      get :demote_admin, params: {id: user}

      expect(response).to redirect_to user_index_path

      user.reload
      expect(user.admin).to eq false
    end

    it 'requires user to be signed in to demote an admin' do
      user = FactoryBot.create(:user, admin: true)
      admin = FactoryBot.create(:user, admin: true)

      get :demote_admin, params: {id: user}

      expect(response).to redirect_to new_user_session_path

      user.reload
      expect(user.admin).to eq true
    end

    it 'only other admins can demote an admin' do
      user = FactoryBot.create(:user, admin: true)
      non_admin = FactoryBot.create(:user, admin: false)
      sign_in non_admin

      get :demote_admin, params: {id: user}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'

      user.reload
      expect(user.admin).to eq true
    end
  end

  describe 'Users#guild_master action' do
    it 'allows guild masters to promote other guild masters' do
      user = FactoryBot.create(:user)
      guild_master = FactoryBot.create(:user, admin: true, guild_master: true)
      sign_in guild_master

      get :guild_master, params: {id: user}

      expect(response).to redirect_to user_index_path
      user.reload

      expect(user.guild_master).to eq true
    end

    it 'requires users to be signed in to promote to guild master' do
      user = FactoryBot.create(:user)
      admin = FactoryBot.create(:user, admin: true, guild_master: true)

      get :guild_master, params: {id: user}

      expect(response).to redirect_to new_user_session_path
      user.reload

      expect(user.guild_master).to eq false
    end

    it 'requires user to be guild master to promote to guild master' do
      user = FactoryBot.create(:user)
      non_guild_master = FactoryBot.create(:user, admin: true)
      sign_in non_guild_master

      get :guild_master, params: {id: user}

      expect(response).to redirect_to root_path
      user.reload
           
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(user.guild_master).to eq false
    end

    it 'requires user to be admin and guild master to promote to guild master' do
      user = FactoryBot.create(:user)
      non_admin = FactoryBot.create(:user, guild_master: true)
      sign_in non_admin

      get :guild_master, params: {id: user}

      expect(response).to redirect_to root_path
      user.reload
           
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(user.guild_master).to eq false
    end
  end

  describe 'Users#demote_guild_master action' do
    it 'allows guild masters to demote other guild masters' do
      user = FactoryBot.create(:user, guild_master: true)
      guild_master = FactoryBot.create(:user, admin: true, guild_master: true)
      sign_in guild_master

      get :demote_guild_master, params: {id: user}

      expect(response).to redirect_to user_index_path
      user.reload

      expect(user.guild_master).to eq false
    end

    it 'requires users to be signed in to promote to guild master' do
      user = FactoryBot.create(:user, guild_master: true)
      admin = FactoryBot.create(:user, admin: true, guild_master: true)

      get :demote_guild_master, params: {id: user}

      expect(response).to redirect_to new_user_session_path
      user.reload

      expect(user.guild_master).to eq true
    end

    it 'requires user to be guild master to promote to guild master' do
      user = FactoryBot.create(:user, guild_master: true)
      non_guild_master = FactoryBot.create(:user, admin: true)
      sign_in non_guild_master

      get :demote_guild_master, params: {id: user}

      expect(response).to redirect_to root_path
      user.reload
           
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(user.guild_master).to eq true
    end

    it 'requires user to be admin and guild master to promote to guild master' do
      user = FactoryBot.create(:user, guild_master: true)
      non_admin = FactoryBot.create(:user, guild_master: true)
      sign_in non_admin

      get :demote_guild_master, params: {id: user}

      expect(response).to redirect_to root_path
      user.reload
           
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(user.guild_master).to eq true
    end

    it 'does not allow guild masters to demote themselves' do
      guild_master = FactoryBot.create(:user, guild_master: true, admin: true)
      sign_in guild_master

      get :demote_guild_master, params: {id: guild_master}

      expect(response).to redirect_to user_index_path
      expect(flash[:alert]).to eq 'You can not demote yourself from Guild Master.'

      guild_master.reload
      expect(guild_master.guild_master).to eq true
    end
  end
  
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
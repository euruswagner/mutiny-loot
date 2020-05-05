require 'rails_helper'

RSpec.describe NewsPostsController, type: :controller do
  describe 'newsposts#create action' do
    it 'allows a News Post to be created' do
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      post :create, params: {news_post: {title: 'Test', message: 'This is a test message.'}}

      news_post = NewsPost.last
      expect(response).to redirect_to news_post_path(news_post)
      expect(news_post.title).to eq 'Test'
      expect(news_post.message).to eq 'This is a test message.'
      expect(news_post.user_id).to eq user.id
    end

    it 'requires 3 letter title' do
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      post :create, params: {news_post: {title: 'Te', message: 'This is a test message.'}}

      expect(response).to redirect_to news_posts_path
      expect(flash[:alert]).to eq 'This news post is not valid.'
      expect(NewsPost.count).to eq 0
    end

    it 'requires 10 letter message' do
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      post :create, params: {news_post: {title: 'Test', message: '8letters'}}

      expect(response).to redirect_to news_posts_path
      expect(flash[:alert]).to eq 'This news post is not valid.'
      expect(NewsPost.count).to eq 0
    end

    it 'requires user to be signed in' do
      user = FactoryBot.create(:user, admin: true)

      post :create, params: {news_post: {title: 'Test', message: 'This is a test message.'}}

      expect(response).to redirect_to new_user_session_path
      expect(NewsPost.count).to eq 0
    end

    it 'requires user to be an admin to create news post' do
      user = FactoryBot.create(:user, admin: false)
      sign_in user

      post :create, params: {news_post: {title: 'Test', message: 'This is a test message.'}}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(NewsPost.count).to eq 0
    end
  end

  describe 'newsposts#updated action' do
    it 'allows newsposts to be updated' do
      user = FactoryBot.create(:user, admin: true)
      news_post = FactoryBot.create(:news_post, user_id: user.id)
      sign_in user

      patch :update, params: {id: news_post.id, news_post: {title: 'Test 2', message: 'This is a second test message.'}}

      expect(response).to redirect_to news_post_path(news_post)
      news_post.reload
      expect(news_post.title).to eq 'Test 2'
      expect(news_post.message).to eq 'This is a second test message.'
    end

    it 'requires updates to have valid length titles' do
      user = FactoryBot.create(:user, admin: true)
      news_post = FactoryBot.create(:news_post, user_id: user.id)
      sign_in user

      patch :update, params: {id: news_post.id, news_post: {title: 'Te', message: 'This is a second test message.'}}

      expect(response).to redirect_to news_post_path(news_post)
      expect(flash[:alert]).to eq 'That update is invalid.'
      news_post.reload
      expect(news_post.title).to eq 'Test'
      expect(news_post.message).to eq 'This is a test message.'
    end

    it 'requires updates to have valid length messages' do
      user = FactoryBot.create(:user, admin: true)
      news_post = FactoryBot.create(:news_post, user_id: user.id)
      sign_in user

      patch :update, params: {id: news_post.id, news_post: {title: 'Test', message: '8letters'}}

      expect(response).to redirect_to news_post_path(news_post)
      expect(flash[:alert]).to eq 'That update is invalid.'
      news_post.reload
      expect(news_post.title).to eq 'Test'
      expect(news_post.message).to eq 'This is a test message.'
    end

    it 'requires users to be logged in' do
      user = FactoryBot.create(:user, admin: true)
      news_post = FactoryBot.create(:news_post, user_id: user.id)

      patch :update, params: {id: news_post.id, news_post: {title: 'Test', message: 'This is a second test message.'}}

      expect(response).to redirect_to new_user_session_path
      news_post.reload
      expect(news_post.title).to eq 'Test'
      expect(news_post.message).to eq 'This is a test message.'
    end

    it 'requires users to be admins' do
      user = FactoryBot.create(:user, admin: false)
      news_post = FactoryBot.create(:news_post, user_id: user.id)
      sign_in user

      patch :update, params: {id: news_post.id, news_post: {title: 'Test', message: 'This is a second test message.'}}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      news_post.reload
      expect(news_post.title).to eq 'Test'
      expect(news_post.message).to eq 'This is a test message.'
    end
  end

  describe 'newsposts#destroy action' do
    it 'allows newsposts to be destroyed' do
      user = FactoryBot.create(:user, admin: true)
      news_post = FactoryBot.create(:news_post, user_id: user.id)
      sign_in user

      delete :destroy, params: {id: news_post.id}

      expect(response).to redirect_to news_posts_path
      expect(flash[:notice]).to eq 'You have successfully deleted a news post.'
      expect(NewsPost.count).to eq 0
    end

    it 'requires users to be logged in to delete news posts' do
      user = FactoryBot.create(:user, admin: true)
      news_post = FactoryBot.create(:news_post, user_id: user.id)

      delete :destroy, params: {id: news_post.id}

      expect(response).to redirect_to new_user_session_path
      news_post.reload
      expect(news_post.title).to eq 'Test'
      expect(news_post.message).to eq 'This is a test message.'
    end

    it 'requires users to be an admin to delete news posts' do
      user = FactoryBot.create(:user, admin: false)
      news_post = FactoryBot.create(:news_post, user_id: user.id)
      sign_in user

      delete :destroy, params: {id: news_post.id}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      news_post.reload
      expect(news_post.title).to eq 'Test'
      expect(news_post.message).to eq 'This is a test message.'
    end
  end
end

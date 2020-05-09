require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'comments#create action' do
    it 'allows a Comment to be created' do
      news_post = FactoryBot.create(:news_post)
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      post :create, params: {news_post_id: news_post.id, comment: {message: 'This is a test message.'}}

      expect(response).to redirect_to news_post_path(news_post)
      comment = Comment.last
      expect(comment.message).to eq 'This is a test message.'
      expect(comment.user_id).to eq user.id
    end

    it 'requires 3 letter message' do
      news_post = FactoryBot.create(:news_post)
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      post :create, params: {news_post_id: news_post.id, comment: {message: 'T'}}

      expect(response).to redirect_to news_post_path(news_post)
      expect(flash[:alert]).to eq 'Comments must have 2 characters'
      expect(Comment.count).to eq 0
    end

    it 'requires user to be signed in' do
      news_post = FactoryBot.create(:news_post)
      user = FactoryBot.create(:user, admin: true)

      post :create, params: {news_post_id: news_post.id, comment: {message: 'This is a test message.'}}

      expect(response).to redirect_to new_user_session_path
      expect(Comment.count).to eq 0
    end

    it " should return http status code of not found if the gram isn't found" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: {news_post_id: 'Test', comment: {message: 'This is a test message.'}}

      expect(response).to have_http_status :not_found
    end
  end

  describe 'comments#updated action' do
    it 'allows comments to be updated' do
      news_post = FactoryBot.create(:news_post)
      user = FactoryBot.create(:user, admin: false)
      comment = FactoryBot.create(:comment, news_post_id: news_post.id, user_id: user.id)
      sign_in user

      patch :update, params: {  use_route: "news_posts/#{news_post.id}/comments/", 
                                news_post_id: news_post.id, 
                                comment_id: comment.id, 
                                comment: {message: 'This is a different message.'}}

      expect(response).to redirect_to news_post_path(news_post)
      comment.reload
      expect(comment.message).to eq 'This is a different message.'
    end

    it 'requires updates to have valid length messages' do
      news_post = FactoryBot.create(:news_post)
      user = FactoryBot.create(:user, admin: false)
      comment = FactoryBot.create(:comment, news_post_id: news_post.id, user_id: user.id)
      sign_in user

      patch :update, params: {  use_route: "news_posts/#{news_post.id}/comments/", 
                                news_post_id: news_post.id, 
                                comment_id: comment.id, 
                                comment: {message: 'T'}}

      expect(response).to redirect_to news_post_path(news_post)
      expect(flash[:alert]).to eq 'Comments must have 2 characters'
      comment.reload
      expect(comment.message).to eq 'This is a test message.'
    end
  
    it 'requires users to be logged in' do
      news_post = FactoryBot.create(:news_post)
      user = FactoryBot.create(:user, admin: false)
      comment = FactoryBot.create(:comment, news_post_id: news_post.id, user_id: user.id)

      patch :update, params: {  use_route: "news_posts/#{news_post.id}/comments/", 
                                news_post_id: news_post.id, 
                                comment_id: comment.id, 
                                comment: {message: 'T'}}

      expect(response).to redirect_to new_user_session_path
      comment.reload
      expect(comment.message).to eq 'This is a test message.'
    end

    it 'shouldn\'t let users who didn\'t create the comment update it' do
      news_post = FactoryBot.create(:news_post)
      user = FactoryBot.create(:user, admin: false)
      comment = FactoryBot.create(:comment, news_post_id: news_post.id)
      sign_in user

      patch :update, params: {  use_route: "news_posts/#{news_post.id}/comments/", 
                                news_post_id: news_post.id, 
                                comment_id: comment.id, 
                                comment: {message: 'This is a different message.'}}

      expect(response).to redirect_to news_post_path(news_post)
      expect(flash[:alert]).to eq 'This is not your comment.'
      comment.reload
      expect(comment.message).to eq 'This is a test message.'
    end
  end

  describe 'comments#destroy action' do
    it 'allows comments to be destroyed' do
      news_post = FactoryBot.create(:news_post)
      user = FactoryBot.create(:user, admin: false)
      comment = FactoryBot.create(:comment, news_post_id: news_post.id, user_id: user.id)
      sign_in user

      delete :destroy, params: {  use_route: "news_posts/#{news_post.id}/comments/", 
                                news_post_id: news_post.id, 
                                comment_id: comment.id}

      expect(response).to redirect_to news_post_path(news_post)
      expect(flash[:notice]).to eq 'You have successfully deleted a comment.'
      expect(Comment.count).to eq 0
    end

    it 'allows comments by a different user to be destroyed by an admin' do
      news_post = FactoryBot.create(:news_post)
      user = FactoryBot.create(:user, admin: true)
      comment = FactoryBot.create(:comment, news_post_id: news_post.id)
      sign_in user

      delete :destroy, params: {  use_route: "news_posts/#{news_post.id}/comments/", 
                                news_post_id: news_post.id, 
                                comment_id: comment.id}

      expect(response).to redirect_to news_post_path(news_post)
      expect(flash[:notice]).to eq 'You have successfully deleted a comment.'
      expect(Comment.count).to eq 0
    end

    it 'requires users to be logged in to delete comments' do
      news_post = FactoryBot.create(:news_post)
      user = FactoryBot.create(:user, admin: false)
      comment = FactoryBot.create(:comment, news_post_id: news_post.id, user_id: user.id)

      delete :destroy, params: {  use_route: "news_posts/#{news_post.id}/comments/", 
                                news_post_id: news_post.id, 
                                comment_id: comment.id}

      expect(response).to redirect_to new_user_session_path
      comment.reload
      expect(comment.message).to eq 'This is a test message.'
      expect(Comment.count).to eq 1
    end

    it 'shouldn\'t let users who didn\'t create the comment delete it' do
      news_post = FactoryBot.create(:news_post)
      user = FactoryBot.create(:user, admin: false)
      comment = FactoryBot.create(:comment, news_post_id: news_post.id)
      sign_in user

      delete :destroy, params: {  use_route: "news_posts/#{news_post.id}/comments/", 
                                news_post_id: news_post.id, 
                                comment_id: comment.id}

      expect(response).to redirect_to news_post_path(news_post)
      expect(flash[:alert]).to eq 'This is not your comment.'
      comment.reload
      expect(comment.message).to eq 'This is a test message.'
      expect(Comment.count).to eq 1
    end
  end
end

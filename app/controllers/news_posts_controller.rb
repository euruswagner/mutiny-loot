class NewsPostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :authenticate_admin!, only: [:create, :update, :destroy]

  def index
    @news_posts = NewsPost.all
    @news_post = NewsPost.new
  end

  def show
    @news_post = news_post
    @comment = Comment.new
  end
 
  def create
    @news_post = NewsPost.create(news_post_params.merge(user: current_user))

    if @news_post.valid?
      redirect_to news_post_path(@news_post)
    else
      redirect_to news_posts_path, alert: 'This news post is not valid.'
    end
  end

  def update
    news_post.assign_attributes(news_post_params)
    news_post.save
    if news_post.valid?
      redirect_to news_post_path(news_post)
    else
      redirect_to news_post_path(news_post), alert: 'That update is invalid.'
    end
  end

  def destroy
    news_post.destroy
    redirect_to news_posts_path, notice: 'You have successfully deleted a news post.'
  end

  private
  
  def news_post
    @news_post ||= NewsPost.find(params[:id])
  end

  def news_post_params
    params.require(:news_post).permit(:title, :message)
  end

  def authenticate_admin!
    if current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end
end

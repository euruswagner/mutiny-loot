class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    news_post = NewsPost.find_by_id(params[:news_post_id])
    return render_not_found if news_post.blank?
    comment = news_post.comments.create(comment_params.merge(user: current_user))
    if comment.valid? then
      return redirect_to news_post_path(news_post)
    else
      return redirect_to news_post_path(news_post), alert: 'Comments must have 2 characters'
    end
  end

  def update
    news_post = NewsPost.find_by_id(params[:news_post_id])
    return render_not_found if news_post.blank?
    comment = news_post.comments.find_by_id(params[:comment_id])
    return render_not_found if comment.blank?

    if comment.user != current_user
      return  redirect_to news_post_path(news_post), alert: 'This is not your comment.'  
    end

    comment.assign_attributes(comment_params)
    comment.save
    if comment.valid? then
      return redirect_to news_post_path(news_post)
    else
      return redirect_to news_post_path(news_post), alert: 'Comments must have 2 characters'
    end
  end

  def destroy
    news_post = NewsPost.find_by_id(params[:news_post_id])
    return render_not_found if news_post.blank?
    comment = news_post.comments.find_by_id(params[:comment_id])
    return render_not_found if comment.blank?


    if comment.user != current_user
      return redirect_to news_post_path(news_post), alert: 'This is not your comment.'
    end
    comment.destroy
    redirect_to news_post_path(news_post), notice: 'You have successfully deleted a comment.'
  end



  private

  def comment_params
    params.require(:comment).permit(:message)
  end

  def render_not_found(status=:not_found)
    render plain: '#{status.to_s.titleize} :(', status: status
  end
end

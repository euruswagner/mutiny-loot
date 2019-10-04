class CommentsController < ApplicationController
before_action :authenticate_user!

  def create
    @item = Item.find(params[:item_id])
    @item.comments.create(comment_params.merge(user: current_user))
    redirect_to item_path(@item)
  end

  private

  def comment_params
    params.require(:comment).permit(:message)
  end

end

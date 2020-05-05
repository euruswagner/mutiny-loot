class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @item = Item.find(params[:item_id])
    @item.comments.create(comment_params.merge(user: current_user))
    redirect_to item_path(@item)
  end

  def edit
    @item = Item.find(params[:item_id])
    @comment = @item.comments.find(params[:id])

    if @comment.user != current_user
      return render plain: 'Not Allowed', status: :forbidden
    end
  end

  def update
    @item = Item.find(params[:item_id])
    @comment = @item.comments.find(params[:id])

    if @comment.user != current_user
      return render plain: 'Not Allowed', status: :forbidden
    end

    @comment.update_attributes(comment_params)
    if @comment.valid?
      redirect_to item_path(@item)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item = Item.find(params[:item_id])
    @comment = @item.comments.find(params[:id])
    if @comment.user != current_user
      return render plain: 'Not Allowed', status: :forbidden
    end
    @comment.destroy
    redirect_to item_path(@item)
  end



  private

  def comment_params
    params.require(:comment).permit(:message)
  end
end

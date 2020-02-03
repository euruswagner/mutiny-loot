class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]

  def show
    @item = Item.find(params[:id])
    @raiders_without_priority_assigned = Raider.all
    @comment = Comment.new
  end

  def edit
    @item = Item.find(params[:id])

    if current_user.admin != true
      return render plain: 'Not Allowed', status: :forbidden
    end
  end

  def update
    @item = Item.find(params[:id])

    if current_user.admin != true
      return render plain: 'Not Allowed', status: :forbidden
    end

    @item.update_attributes(item_params)
    if @item.valid?
      redirect_to item_path(@item)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:link, :priority, :zone, :winner)
  end
end

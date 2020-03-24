class PrioritiesController < ApplicationController
  before_action :authenticate_user!

  def create
    item = Item.find(params[:item_id])
    priority = item.priorities.create(priority_params)
    if priority.valid?
      redirect_to item_path(item)
    else
      redirect_to item_path(item), alert: 'The ranking you have entered is incorrrect.'
    end
  end

  def destroy
    item = Item.find(params[:item_id])
    priority = item.priorities.find(params[:priority_id])
    priority.destroy
    redirect_to item_path(item)
  end

  private

  def priority_params
    params.require(:priority).permit(:raider_id, :ranking)
  end
end

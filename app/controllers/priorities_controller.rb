class PrioritiesController < ApplicationController
  before_action :authenticate_user!

  def create
    item = Item.find(params[:item_id])
    item.priorities.create(priority_params)
    redirect_to item_path(item)
  end

  private

  def priority_params
    params.require(:priority).permit(:raider_id, :ranking)
  end
end

class PrioritiesController < ApplicationController
  def create
    item = Item.find(params[:item_id])
    item.priorities.create(priority_params)
  end

  private

  def priority_params
    params.require(:priority).permit(:raider_id, :ranking)
  end
end

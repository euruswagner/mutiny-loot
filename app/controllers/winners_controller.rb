class WinnersController < ApplicationController
  before_action :authenticate_user!

  def create
    item = Item.find(params[:item_id])
    item.winners.create(winner_params)
    redirect_to item_path(item)
  end

  def destroy
    item = Item.find(params[:item_id])
    winner = item.winners.find(params[:winner_id])
    winner.destroy
    redirect_to item_path(item)
  end

  private

  def winner_params
    params.require(:winner).permit(:raider_id, :points_spent)
  end
end

class WinnersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :authenticate_admin!, only: [:create, :destroy]

  def index
    @raider = Raider.find(params[:raider_id])
    @winnings = Winner.where(raider_id: @raider)
  end

  def create
    item = Item.find_by_id(params[:item_id])
    raider = Raider.find_by_id(winner_params[:raider_id])
    winner = item.winners.create(winner_params)
    if winner.valid?
      points_spent = winner.points_spent
      raider.update_total_points_spent(points_spent)
      redirect_to raider_path(raider)
    else
      redirect_to item_path(item), alert: 'There was an error creating this.'
    end
  end

  def destroy
    item = Item.find_by_id(params[:item_id])
    winner = item.winners.find_by_id(params[:id])
    raider = Raider.find_by_id(winner.raider_id)
    points_refunded = winner.points_spent * -1
    winner.destroy
    raider.update_total_points_spent(points_refunded)
    redirect_to item_path(item)
  end

  private

  def winner_params
    params.require(:winner).permit(:raider_id, :points_spent, :priority_id)
  end

  def authenticate_admin!
    if current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end
end

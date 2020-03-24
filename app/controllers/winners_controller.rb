class WinnersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

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
    winner = item.winners.find_by_id(params[:winner_id])
    raider = Raider.find_by_id(winner.raider_id)
    points_refunded = winner.points_spent * -1
    winner.destroy
    raider.update_total_points_spent(points_refunded)
    redirect_to item_path(item)
  end

  private

  def winner_params
    params.require(:winner).permit(:raider_id, :points_spent)
  end

  def authenticate_admin!
    if current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end
end

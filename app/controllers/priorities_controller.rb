class PrioritiesController < ApplicationController
  before_action :authenticate_user!
  before_action :maximum_two_priorities_per_ranking, only: :create
  before_action :priority_is_locked?, only: :update
  before_action :valid_priority?, only: :update
  before_action :authenticate_admin!, only: [:lock, :unlock]

  def create
    item = Item.find(params[:item_id])
    priority = item.priorities.create(priority_params)
    raider = priority.raider
    if priority.valid? && priority.phase == 3
      redirect_to item_path(item)
    elsif priority.valid?
      redirect_to raider_path(raider, anchor: 'aq')
    else
      redirect_to item_path(item), alert: 'The ranking you have entered is incorrrect.'
    end
  end

  def update
    item = Item.find_by_id(params[:item_id])
    return render_not_found if item.blank?
    priority = Priority.find_by_id(params[:id])
    return render_not_found if priority.blank?
    raider = priority.raider

    if priority.raider.user != current_user && current_user.admin == false
      return  redirect_to raiders_path, alert: 'This is not your list.'  
    end

    priority.assign_attributes(priority_params)
    priority.save
    if priority.valid? then
      return redirect_to raider_path(raider, anchor: 'aq')
    else
      return redirect_to raider_path(raider), alert: 'This was not a valid update.'
    end
  end

  def destroy
    item = Item.find(params[:item_id])
    priority = item.priorities.find(params[:priority_id])
    phase = priority.phase
    raider = priority.raider
    priority.destroy
    if phase == 3
      redirect_to item_path(item)
    else
      redirect_to raider_path(raider)
    end
  end

  def lock
    raider = Raider.find(params[:id])
    raider.lock_priorities
    redirect_to raider_path(raider)
  end

  def unlock
    raider = Raider.find(params[:id])
    raider.unlock_priorities
    redirect_to raider_path(raider)
  end

  private

  def priority_params
    params.require(:priority).permit(:raider_id, :ranking, :phase, :locked)
  end

  def maximum_two_priorities_per_ranking
    item = Item.find(params[:item_id])
    raider_id = priority_params[:raider_id].to_i
    raider = Raider.find(raider_id)
    ranking = priority_params[:ranking].to_i
    phase = priority_params[:phase].to_i
    
    if raider.priorities.where(ranking: ranking, phase: phase).count >= 2 && phase == 3
      redirect_to item_path(item), alert: 'You have more than two items at a ranking.'
    elsif raider.priorities.where(ranking: ranking, phase: phase).count >= 2
      redirect_to raider_path(raider), alert: 'You have to many items at a priority. Try removing some items from line 25.'
    end 
  end

  def priority_is_locked?
    priority = Priority.find_by_id(params[:id])
    raider = priority.raider
    if priority.locked?
      redirect_to raider_path(raider), alert: 'You can not edit your list at this time.'
    end
  end

  def valid_priority?
    priority = Priority.find_by_id(params[:id])
    raider = priority.raider
    ranking = priority_params[:ranking].to_i
    if not priority.valid_priority?(ranking)
      redirect_to raider_path(raider), alert: 'That is not a valid priority.'
    end
  end

  def render_not_found(status=:not_found)
    render plain: '#{status.to_s.titleize} :(', status: status
  end

  def authenticate_admin!
    if current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end
end

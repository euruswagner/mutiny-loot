class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:approve, :connect]
  
  def show
    @user = User.find(params[:id])
    @unapproved_users = User.where(approved: false)
    @unconnected_users = User.where(raider_id: nil)
    @raiders = Raider.all
  end

  def approve
    @user = User.find(params[:id])

    @user.update_attributes(:approved => true)
    redirect_to user_path(current_user)
  end

  def connect
    @user = User.find(params[:user_id])
    @raider = Raider.find(params[:raider_id])

    @user.raider_id = @raider.id
    @raider.user_id = @user.id
    @user.save
    @raider.save
    redirect_to user_path(current_user)
  end

  private

  def authenticate_admin!
    if current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end
end

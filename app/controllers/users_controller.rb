class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = User.find(params[:id])
    @unapproved_users = User.where(:approved => false)
    @raiders = Raider.all
  end

  def approve
    @user = User.find(params[:id])

    @user.update_attributes(:approved => true)
    redirect_to user_path(current_user)
  end

end

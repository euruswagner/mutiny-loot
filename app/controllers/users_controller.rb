class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = User.find(params[:id])
  end

  def approve
    @user = User.find(params[:id])

    @user.update_attributes(:approved => true)
    redirect_to user_path(current_user)
  end

end

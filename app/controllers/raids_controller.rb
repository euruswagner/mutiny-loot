class RaidsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :authenticate_admin!, only: [:create, :update, :destroy]
  
  def index
    @raids = Raid.all
  end

  def show
    @raid = raid
    @signup = Signup.new
  end

  def create
    @raid = Raid.create(raid_params)
    if @raid.valid?
      redirect_to calendar_path
    else
      redirect_to calendar_path, alert: 'The information you have entered is incomplete.'
    end
  end

  def update
    raid.assign_attributes(raid_params)
    raid.save
    if raid.valid?
      redirect_to raid_path(raid)
    else
      redirect_to raid_path(raid), alert: 'That update is invalid.'
    end
  end

  def destroy
    raid.destroy
    redirect_to calendar_path, notice: 'You have successfully deleted a raid.'
  end
  
  private
    
  def raid
    @raid ||= Raid.find(params[:id])
  end

  def raid_params
    params.require(:raid).permit(:name, :start_time)
  end

  def authenticate_admin!
    if current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end
end

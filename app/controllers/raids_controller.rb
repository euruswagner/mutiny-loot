class RaidsController < ApplicationController
  before_action :set_raid, only: :show
  before_action :authenticate_user!, only: :create
  before_action :authenticate_admin!, only: :create
  
  def index
    @raids = Raid.all
  end

  def show
  end

  def create
    @raid = Raid.create(raid_params)
    if @raid.valid?
      redirect_to calendar_path
    else
      redirect_to calendar_path, alert: 'The information you have entered is incomplete.'
    end
  end
  
  private
    
  def set_raid
    @raid = Raid.find(params[:id])
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

class RaidersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update]
  before_action :authenticate_admin!, only: [:new, :create, :update]

  def index
    @raiders = Raider.all
  end

  def show
    @raider = Raider.find(params[:id])
  end

  def new
    @raider = Raider.new
  end

  def create
    @raider = Raider.create(raider_params)
    if @raider.valid?
      redirect_to raider_path(@raider)
    else
      redirect_to new_raider_path, alert: 'The information you have entered is incomplete.'
    end
  end

  def update
    @raider = Raider.find(params[:id])
    @raider.assign_attributes(raider_params)
    @raider.save
    if @raider.valid?
      redirect_to raider_path(@raider)
    else
      redirect_to raider_path(@raider), alert: 'That update is invalid.'
    end
  end

  private

  def raider_params
    params.require(:raider).permit(:name, :which_class, :role)
  end

  def authenticate_admin!
    if current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end
end

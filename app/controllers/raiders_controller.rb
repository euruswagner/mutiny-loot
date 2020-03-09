class RaidersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit]
  before_action :authenticate_admin!, only: [:create]

  def index
    @raiders = Raider.all
  end

  def show
    @raider = Raider.find(params[:id])
  end

  def create
    Raider.create(raider_params)
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

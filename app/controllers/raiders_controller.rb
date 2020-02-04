class RaidersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @raiders = Raider.all
  end

  def show
    @raider = Raider.find(params[:id])
  end

  def create
    Raider.create
  end
end

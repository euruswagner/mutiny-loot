class RaidersController < ApplicationController
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

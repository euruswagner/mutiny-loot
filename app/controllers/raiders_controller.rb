class RaidersController < ApplicationController
  def show
    @raider = Raider.all
  end

  def create
    Raider.create
  end
end

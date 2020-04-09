class SignupsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]
  before_action :authenticate_admin!, only: :update

  def create
    @raid = Raid.find(params[:raid_id])
    @raid.signups.create(user: current_user)
    redirect_to raid_path(@raid)
  end

  private

  def signup_params
    params.require(:signup)
  end
end

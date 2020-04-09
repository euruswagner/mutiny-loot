class SignupsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]
  before_action :authenticate_admin!, only: :update

  def create
    @raid = Raid.find(params[:raid_id])
    @signup = @raid.signups.create(user: current_user)
    if @signup.valid?
      redirect_to raid_path(@raid), notice: 'You have signed up for this raid see you then.'
    else
      redirect_to raid_path(@raid), alert: 'You have already signed up for this raid.'
    end
  end

  private

  def signup_params
    params.require(:signup)
  end
end

class SignupsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]
  before_action :signup_period?, only: :create
  before_action :authenticate_admin!, only: :update

  def create
    signup = raid.signups.create(user: current_user)
    if signup.valid?
      redirect_to raid_path(raid), notice: 'You have signed up for this raid see you then.'
    else
      redirect_to raid_path(raid), alert: 'You have already signed up for this raid.'
    end
  end

  private

  def raid
    @raid ||= Raid.find(params[:raid_id])
  end

  def signup_params
    params.require(:signup)
  end

  def signup_period?
    start_time = raid.start_time
    open_time = start_time - 7.days
    time_till_raid = start_time - Time.now
    if time_till_raid > 604800 
      redirect_to raid_path(raid), alert: "You can not currently sign up for this raid. Signups open #{open_time.strftime("%B %-d, %Y %l:%M %p")}"
    end
    if time_till_raid < 0
      redirect_to raid_path(raid), alert: 'You can not sign up for raids that have already occured.'
    end
  end
end

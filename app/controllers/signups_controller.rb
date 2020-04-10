class SignupsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :signup_period?, only: :create
  before_action :correct_user?, only: :destroy

  def create
    signup = raid.signups.create(signup_params.merge(user: current_user))
    if signup.valid?
      redirect_to raid_path(raid), notice: 'You have signed up for this raid see you then.'
    else
      redirect_to raid_path(raid), alert: 'You have either already signed up for this raid or your note is to long.'
    end
  end

  def destroy
    signup = Signup.find(params[:id])
    signup.destroy
    redirect_to raid_path(raid), notice: 'You have eliminated your sign up for this raid.'
  end

  private

  def raid
    @raid ||= Raid.find(params[:raid_id])
  end

  def signup_params
    params.require(:signup).permit(:notes)
  end

  def signup_period?
    start_time = raid.start_time
    open_time = start_time - 7.days
    time_till_raid = start_time - Time.now
    if time_till_raid > 604800 
      redirect_to raid_path(raid), alert: "You can not currently sign up for this raid. Sign ups open #{open_time.strftime("%B %-d, %Y %l:%M %p")}"
    end
    if time_till_raid < 0
      redirect_to raid_path(raid), alert: 'You can not sign up for raids that have already occured.'
    end
  end

  def correct_user?
    signup = Signup.find(params[:id])
    if signup.user != current_user
      redirect_to raid_path(raid), alert: 'This is not your raid sign up.'
    end
  end
end

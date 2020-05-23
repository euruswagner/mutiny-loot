class AttendancesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :authenticate_admin!, only: [:create, :destroy]

  def index
    @raider = Raider.find(params[:raider_id])
    @attendances = Attendance.where(raider_id: @raider)
  end

  def create
    raider = Raider.find(params[:raider_id])
    attendance = raider.attendances.create(attendance_params)
    if attendance.valid? && attendance.notes == 'No Call - No Show'
      points_earned = attendance.points
      raider.update_total_points_earned(points_earned)
      redirect_to raider_path(raider)
    elsif attendance.valid?
      points_earned = attendance.points
      raider.update_total_points_earned(points_earned)
    else
      redirect_to user_path(current_user), alert: 'That attendance was not valid.'
    end
  end

  def destroy
    raider = Raider.find(params[:raider_id])
    attendance = raider.attendances.find(params[:id])
    points_not_earned = attendance.points * -1
    attendance.destroy
    raider.update_total_points_earned(points_not_earned)
    redirect_to raider_path(raider)
  end
  
  private

  def attendance_params
    params.require(:attendance).permit(:notes, :points)
  end

  def authenticate_admin!
    if current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end
end

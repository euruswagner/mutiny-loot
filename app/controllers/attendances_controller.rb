class AttendancesController < ApplicationController
  before_action :authenticate_user!

  def create
    raider = Raider.find(params[:raider_id])
    raider.attendances.create(attendance_params)
  end

  def destroy
    raider = Raider.find(params[:raider_id])
    attendance = raider.attendances.find(params[:attendance_id])
    attendance.destroy
    redirect_to raider_path(raider)
  end
  
  private

  def attendance_params
    params.require(:attendance).permit(:notes, :points)
  end
end

class AttendancesController < ApplicationController
  def create
    raider = Raider.find(params[:raider_id])
    raider.attendances.create(attendance_params)
  end
  
  private

  def attendance_params
    params.require(:attendance).permit(:notes, :points)
  end
end

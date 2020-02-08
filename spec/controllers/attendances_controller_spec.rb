require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
  describe 'attendances#create action' do
    it 'allows attendances to be created' do
      raider = FactoryBot.create(:raider)
      user = FactoryBot.create(:user)
      sign_in user
      
      post :create, params: {raider_id: raider.id, attendance: {notes: 'test', points: 0.2}}

      attendance = Attendance.last
      expect(attendance.notes).to eq('test')
      expect(attendance.points).to eq 0.2
    end
  end
end

require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
  describe 'attendances#create action' do
    it 'allows attendances to be created' do
      raider = FactoryBot.create(:raider)
      
      post :create, params: {raider_id: raider.id, attendance: {notes: 'test', points: 0.2}}

      expect(Attendance.last.notes).to eq('test')
      expect(Attendance.last.points).to eq 0.2
    end
  end
end

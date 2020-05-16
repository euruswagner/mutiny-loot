require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
  describe 'attendances#create action' do
    it 'allows attendances to be created and updates total points earned' do
      User.destroy_all
      raider = FactoryBot.create(:raider, total_points_spent: 0.6, total_points_earned: 5.0)
      user = FactoryBot.create(:user, admin: true)
      sign_in user
      
      post :create, params: {raider_id: raider.id, attendance: {notes: 'test', points: 0.2}}

      attendance = Attendance.last
      expect(attendance.notes).to eq('test')
      expect(attendance.points).to eq 0.2

      raider.reload
      expect(raider.total_points_spent).to eq 0.6
      expect(raider.total_points_earned).to eq 5.2
    end

    it 'Creates No Call - No Show' do
      raider = FactoryBot.create(:raider, total_points_spent: 0.6, total_points_earned: 5.0)
      user = FactoryBot.create(:user, admin: true)
      sign_in user
      
      post :create, params: {raider_id: raider.id, attendance: {notes: 'No Call - No Show', points: -0.2}}

      expect(response).to redirect_to raider_path(raider)
      attendance = Attendance.last
      expect(attendance.notes).to eq('No Call - No Show')
      expect(attendance.points).to eq -0.2

      raider.reload
      expect(raider.total_points_spent).to eq 0.6
      expect(raider.total_points_earned).to eq 4.8
    end

    it 'Redirects if validation fails' do
      raider = FactoryBot.create(:raider, total_points_spent: 0.6, total_points_earned: 5.0)
      user = FactoryBot.create(:user, admin: true)
      sign_in user
      
      post :create, params: {raider_id: raider.id, attendance: {notes: '', points: 0.2}}

      expect(response).to redirect_to user_path(user)
      expect(Attendance.count).to eq 0

      raider.reload
      expect(raider.total_points_spent).to eq 0.6
      expect(raider.total_points_earned).to eq 5.0
    end

    it 'requires user to be signed in' do
      raider = FactoryBot.create(:raider, total_points_spent: 0.6, total_points_earned: 5.0)
      user = FactoryBot.create(:user)

      post :create, params: {raider_id: raider.id, attendance: {notes: 'test', points: 0.2}}

      expect(response).to redirect_to new_user_session_path
      expect(Attendance.count).to eq 0

      raider.reload
      expect(raider.total_points_spent).to eq 0.6
      expect(raider.total_points_earned).to eq 5.0
    end

    it 'requires user to be an admin' do
      raider = FactoryBot.create(:raider, total_points_spent: 0.6, total_points_earned: 5.0)
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: {raider_id: raider.id, attendance: {notes: 'test', points: 0.2}}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(Attendance.count).to eq 0

      raider.reload
      expect(raider.total_points_spent).to eq 0.6
      expect(raider.total_points_earned).to eq 5.0
    end
  end

  describe 'attendances#destroy action' do
    it 'allows attendances to be destroyed and updates total points earned' do
      raider = FactoryBot.create(:raider, total_points_spent: 0.6, total_points_earned: 5.0)
      user = FactoryBot.create(:user, admin: true)
      attendance = FactoryBot.create(:attendance, points: 0.2, raider: raider)
      sign_in user

      delete :destroy, params: {use_route: "raiders/#{raider.id}/attendances/", attendance_id: attendance.id, raider_id: raider.id}

      expect(Attendance.count).to eq 0
      expect(response).to redirect_to raider_path(raider)
      
      raider.reload
      expect(raider.total_points_spent).to eq 0.6
      expect(raider.total_points_earned).to eq 4.8
    end

    it 'requires user to be signed in' do
      raider = FactoryBot.create(:raider, total_points_spent: 0.6, total_points_earned: 5.0)
      user = FactoryBot.create(:user)
      attendance = FactoryBot.create(:attendance, points: 0.2, raider: raider)

      delete :destroy, params: {use_route: "raiders/#{raider.id}/attendances/", attendance_id: attendance.id, raider_id: raider.id}

      expect(response).to redirect_to new_user_session_path
      expect(Attendance.count).to eq 1

      raider.reload
      expect(raider.total_points_spent).to eq 0.6
      expect(raider.total_points_earned).to eq 5.0
    end

    it 'requires user to be admin' do
      raider = FactoryBot.create(:raider, total_points_spent: 0.6, total_points_earned: 5.0)
      user = FactoryBot.create(:user)
      attendance = FactoryBot.create(:attendance, points: 0.2, raider: raider)
      sign_in user

      delete :destroy, params: {use_route: "raiders/#{raider.id}/attendances/", attendance_id: attendance.id, raider_id: raider.id}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'
      expect(Attendance.count).to eq 1

      raider.reload
      expect(raider.total_points_spent).to eq 0.6
      expect(raider.total_points_earned).to eq 5.0
    end
  end
end

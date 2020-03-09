require 'rails_helper'

RSpec.describe RaidersController, type: :controller do
  describe 'raiders#create action' do
    it 'allows raiders to be created' do
      user = FactoryBot.create(:user, admin: true)
      sign_in user

      post :create, params: {raider: {name: 'Test', which_class: 'Shaman', role: 'Elemental'}}

      last_raider = Raider.last
      expect(last_raider.name).to eq 'Test'
      expect(last_raider.which_class).to eq 'Shaman'
      expect(last_raider.role).to eq 'Elemental'
    end

    it 'does not allow non admins to create raiders' do
      user = FactoryBot.create(:user, admin: false)
      sign_in user

      post :create, params: {raider: {name: 'Test', which_class: 'Shaman', role: 'Elemental'}}

      expect(response).to redirect_to root_path
      expect(Raider.count).to eq 0
    end
  end
end

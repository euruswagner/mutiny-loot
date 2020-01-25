require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  describe "lists#create action" do
    it "should allow users to create lists" do
      item = FactoryBot.create(:item)

      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: {item_id: item.id, list: {rank: 1}}

      expect(item.lists.first.rank).to eq 1
      expect(item.lists.length).to eq 1
      #not quite what I want
      expect(response).to redirect_to root_path 
    end
  end
end
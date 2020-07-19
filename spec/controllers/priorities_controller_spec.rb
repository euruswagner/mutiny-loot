require 'rails_helper'

RSpec.describe PrioritiesController, type: :controller do
  describe 'priorities#create action' do
    it 'allows priorities to be created and in phase 3 redirects to item' do
      User.destroy_all
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      user = FactoryBot.create(:user)
      sign_in user
      
      post :create, params: {item_id: item.id, priority: {raider_id: raider.id, ranking: 50}}

      expect(response).to redirect_to item_path(item)
      priority = Priority.last
      expect(priority.ranking).to eq 50
    end

    it 'allows priorities to be created and in something other then phase 3 redirects to raider' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      user = FactoryBot.create(:user)
      sign_in user
      
      post :create, params: {item_id: item.id, priority: {raider_id: raider.id, ranking: 50, phase: 5}}

      expect(response).to redirect_to raider_path(raider, anchor: 'aq')
      priority = Priority.last
      expect(priority.ranking).to eq 50
    end

    it 'does not allow more then two items to be created with the same ranking and in phase 5 redirects to raider' do
      Priority.destroy_all
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 25, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 25, phase: 5)
      user = FactoryBot.create(:user)
      sign_in user
      
      post :create, params: {item_id: item.id, priority: {raider_id: raider.id, ranking: 25, phase: 5}}

      expect(response).to redirect_to raider_path(raider)
      expect(flash[:alert]).to eq 'You have to many items at a priority. Try removing some items from line 25.'
      expect(Priority.count).to eq 2
    end

    it 'does not allow more then two items to be created with the same ranking and in phase 6 redirects to raider' do
      Priority.destroy_all
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 25, phase: 6)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 25, phase: 6)
      user = FactoryBot.create(:user)
      sign_in user
      
      post :create, params: {item_id: item.id, priority: {raider_id: raider.id, ranking: 25, phase: 6}}

      expect(response).to redirect_to raider_path(raider)
      expect(flash[:alert]).to eq 'You have to many items at a priority. Try removing some items from line 25.'
      expect(Priority.count).to eq 2
    end

    it 'does not allow more then two items to be created with the same ranking and in phase 3 redirects to item' do
      Priority.destroy_all
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 50, phase: 3)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 50, phase: 3)
      user = FactoryBot.create(:user)
      sign_in user
      
      post :create, params: {item_id: item.id, priority: {raider_id: raider.id, ranking: 50, phase: 3}}

      expect(response).to redirect_to item_path(item)
      expect(flash[:alert]).to eq 'You have more than two items at a ranking.'
      expect(Priority.count).to eq 2
    end

    it 'it ignores items from different phases and successfully creates' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 25, phase: 3)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 25, phase: 3)
      user = FactoryBot.create(:user)
      sign_in user
      
      post :create, params: {item_id: item.id, priority: {raider_id: raider.id, ranking: 25, phase: 5}}

      expect(response).to redirect_to raider_path(raider, anchor: 'aq')
      priority = Priority.last
      expect(priority.ranking).to eq 25
    end
  end

  describe 'priorities#update action' do
    it 'allows priorities to be updated' do
      user = FactoryBot.create(:user)
      raider = FactoryBot.create(:raider, user_id: user.id)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, item_id: item.id, raider_id: raider.id, locked: false)
      sign_in user
      
      patch :update, params: {  use_route: "items/#{item.id}/priorities/", 
                                item_id: item.id, 
                                id: priority.id, 
                                priority: {ranking: 32}}

      expect(response).to redirect_to raider_path(raider, anchor: 'aq')
      priority.reload
      expect(priority.ranking).to eq 32
    end

    it 'does not allow a third priority for a ranking' do
      user = FactoryBot.create(:user)
      raider = FactoryBot.create(:raider, user_id: user.id)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      item3 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 5)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5)
      sign_in user

      patch :update, params: {  use_route: "items/#{item3.id}/priorities/", 
                                item_id: item3.id, 
                                id: priority3.id, 
                                priority: {ranking: 48}}

      priority3.reload
      expect(priority3.ranking).to eq 47
    end
  end

  describe 'priorities#lock action' do
    it 'locks all priorities' do  
      user = FactoryBot.create(:user, admin: true)
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      item3 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 5, locked: false)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5, locked: false)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5, locked: false)
      sign_in user

      get :lock, params: {  use_route: "raiders/#{raider.id}/lock",
                            id: raider.id }

      expect(response).to redirect_to raider_path(raider)

      priority1.reload
      priority2.reload
      priority3.reload
      expect(priority1.locked).to eq true
      expect(priority2.locked).to eq true
      expect(priority3.locked).to eq true
    end

    it 'locks all priorities with some from different phases and locked' do  
      user = FactoryBot.create(:user, admin: true)
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      item3 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 3, locked: true)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5, locked: false)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5, locked: false)
      sign_in user

      get :lock, params: {  use_route: "raiders/#{raider.id}/lock",
                            id: raider.id }

      expect(response).to redirect_to raider_path(raider)

      priority1.reload
      priority2.reload
      priority3.reload
      expect(priority1.locked).to eq true
      expect(priority2.locked).to eq true
      expect(priority3.locked).to eq true
    end

    it 'requires user to be signed in' do  
      user = FactoryBot.create(:user, admin: true)
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      item3 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 3, locked: true)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5, locked: false)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5, locked: false)

      get :lock, params: {  use_route: "raiders/#{raider.id}/lock",
                            id: raider.id }

      expect(response).to redirect_to new_user_session_path

      priority1.reload
      priority2.reload
      priority3.reload
      expect(priority1.locked).to eq true
      expect(priority2.locked).to eq false
      expect(priority3.locked).to eq false
    end

    it 'requires user to be an admin' do  
      user = FactoryBot.create(:user, admin: false)
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      item3 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 3, locked: true)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5, locked: false)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5, locked: false)
      sign_in user

      get :lock, params: {  use_route: "raiders/#{raider.id}/lock",
                            id: raider.id }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'

      priority1.reload
      priority2.reload
      priority3.reload
      expect(priority1.locked).to eq true
      expect(priority2.locked).to eq false
      expect(priority3.locked).to eq false
    end
  end

  describe 'priorities#lock action' do
    it 'unlocks all priorities' do  
      user = FactoryBot.create(:user, admin: true)
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      item3 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 5, locked: true)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5, locked: true)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5, locked: true)
      sign_in user

      get :unlock, params: {  use_route: "raiders/#{raider.id}/unlock",
                            id: raider.id }

      expect(response).to redirect_to raider_path(raider)

      priority1.reload
      priority2.reload
      priority3.reload
      expect(priority1.locked).to eq false
      expect(priority2.locked).to eq false
      expect(priority3.locked).to eq false
    end

    it 'unlocks all phase 5 priorities but not phase 3' do  
      user = FactoryBot.create(:user, admin: true)
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      item3 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 3, locked: true)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5, locked: true)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5, locked: true)
      sign_in user

      get :unlock, params: {  use_route: "raiders/#{raider.id}/unlock",
                            id: raider.id }

      expect(response).to redirect_to raider_path(raider)

      priority1.reload
      priority2.reload
      priority3.reload
      expect(priority1.locked).to eq true
      expect(priority2.locked).to eq false
      expect(priority3.locked).to eq false
    end

    it 'requires user to be signed in' do  
      user = FactoryBot.create(:user, admin: true)
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      item3 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 3, locked: true)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5, locked: true)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5, locked: true)

      get :unlock, params: {  use_route: "raiders/#{raider.id}/unlock",
                            id: raider.id }

      expect(response).to redirect_to new_user_session_path

      priority1.reload
      priority2.reload
      priority3.reload
      expect(priority1.locked).to eq true
      expect(priority2.locked).to eq true
      expect(priority3.locked).to eq true
    end

    it 'requires user to be an admin' do  
      user = FactoryBot.create(:user, admin: false)
      raider = FactoryBot.create(:raider)
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      item3 = FactoryBot.create(:item)
      priority1 = FactoryBot.create(:priority, raider: raider, item: item1, ranking: 48, phase: 3, locked: true)
      priority2 = FactoryBot.create(:priority, raider: raider, item: item2, ranking: 48, phase: 5, locked: true)
      priority3 = FactoryBot.create(:priority, raider: raider, item: item3, ranking: 47, phase: 5, locked: true)
      sign_in user

      get :unlock, params: {  use_route: "raiders/#{raider.id}/unlock",
                            id: raider.id }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.'

      priority1.reload
      priority2.reload
      priority3.reload
      expect(priority1.locked).to eq true
      expect(priority2.locked).to eq true
      expect(priority3.locked).to eq true
    end
  end

  describe 'priorities#destroy action' do
    it 'destroys a phase 3 priority when user is admin' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item, ranking: 48, phase: 3, locked: true)
      admin = FactoryBot.create(:user, admin: true)
      sign_in admin

      delete :destroy, params: {use_route: "items/#{item.id}/priorities/", item_id: item.id, priority_id: priority.id}

      expect(response).to redirect_to item_path(item)    

      expect(Priority.count).to eq 0
    end

    it 'requires user to be signed in to delete priority' do
      raider = FactoryBot.create(:raider)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item, ranking: 48, phase: 3, locked: true)
      admin = FactoryBot.create(:user, admin: true)

      delete :destroy, params: {use_route: "items/#{item.id}/priorities/", item_id: item.id, priority_id: priority.id}

      expect(response).to redirect_to new_user_session_path
   
      expect(Priority.count).to eq 1
    end

    it 'User can delete their own unlocked phase 5 priority' do
      non_admin = FactoryBot.create(:user, admin: false)
      raider = FactoryBot.create(:raider, user: non_admin)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item, ranking: 48, phase: 5, locked: false)
      sign_in non_admin

      delete :destroy, params: {use_route: "items/#{item.id}/priorities/", item_id: item.id, priority_id: priority.id}

      expect(response).to redirect_to raider_path(raider)

      expect(Priority.count).to eq 0
    end
    
    it 'requires admin to delete phase 3 priority' do
      non_admin = FactoryBot.create(:user, admin: false)
      raider = FactoryBot.create(:raider, user: non_admin)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item, ranking: 48, phase: 3, locked: false)
      sign_in non_admin

      delete :destroy, params: {use_route: "items/#{item.id}/priorities/", item_id: item.id, priority_id: priority.id}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.' 

      expect(Priority.count).to eq 1
    end

    it 'requires admin to delete phase 5 locked priority' do
      non_admin = FactoryBot.create(:user, admin: false)
      raider = FactoryBot.create(:raider, user: non_admin)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item, ranking: 48, phase: 5, locked: true)
      sign_in non_admin

      delete :destroy, params: {use_route: "items/#{item.id}/priorities/", item_id: item.id, priority_id: priority.id}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.' 

      expect(Priority.count).to eq 1
    end

    it 'User can not delete a different users unlocked phase 5 priority' do
      other_user = FactoryBot.create(:user, admin: false)
      raider = FactoryBot.create(:raider, user: other_user)
      item = FactoryBot.create(:item)
      priority = FactoryBot.create(:priority, raider: raider, item: item, ranking: 48, phase: 5, locked: false)
      non_admin = FactoryBot.create(:user, admin: false)
      sign_in non_admin

      delete :destroy, params: {use_route: "items/#{item.id}/priorities/", item_id: item.id, priority_id: priority.id}

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You do not have the privileges required to do that.' 

      expect(Priority.count).to eq 1
    end
  end
end

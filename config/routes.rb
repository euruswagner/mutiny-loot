Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'categories#index'
  resources :categories, only: :show
  resources(:items, {:only => :show}) do 
    resources(:comments, {:only => [:create, :edit, :update, :destroy]})
  end
end

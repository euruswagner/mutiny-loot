Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'categories#index'
  resources :categories, only: :show
  resources :items, only: [:show, :edit, :update] do 
    resources :priorities, only: [:create, :destroy]
    resources :winners, only: [:create, :destroy]
    resources :comments, only: [:create, :edit, :update, :destroy]    
  end
  resources :users, only: :show 
  resources :raiders, only: [:index, :show] do
    resources :attendances, only: [:create, :destroy]
  end
  get "/users/approve/:id", to: 'users#approve'
  get '/search' => 'pages#search', :as => 'search_page'
end
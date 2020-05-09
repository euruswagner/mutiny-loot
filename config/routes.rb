Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  
  root 'pages#frontpage'
  resources :categories, only: [:show, :index]
  
  resources :items, only: [:show, :edit, :update] do 
    resources :priorities, only: [:create, :destroy]
    resources :winners, only: [:create, :destroy]
  end
  
  resources :users, only: :show do 
    root :to => "welcome#index"
  end

  resources :raiders, only: [:index, :show, :new, :create, :update] do
    resources :attendances, only: [:create, :destroy]
  end
  
  resources :raids, only: [:show, :create, :update, :destroy] do
    resources :signups, only: [:create, :destroy]
  end
  
  resources :news_posts, only: [:index, :show, :create, :update, :destroy] do
    resources :comments, only: [:create, :update, :destroy]
  end

  get '/users/approve/:id', to: 'users#approve'
  get '/users/:user_id/connect/:raider_id', to: 'users#connect'
  # get '/search' => 'pages#search', :as => 'search_page' <-- keep just in case there is an issue
  get '/search', to: 'pages#search', as: 'search_page' #reformat to match other syntax
  get '/calendar', to: 'pages#calendar'
end

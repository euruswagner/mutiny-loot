Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  
  root 'pages#frontpage'
  resources :categories, only: [:show, :index]
  
  resources :items, only: [:show, :edit, :update] do 
    resources :priorities, only: [:create, :update, :destroy]
    resources :winners, only: [:create, :destroy]
  end
  
  resources :users, only: :show do 
    root :to => 'pages#frontpage'
  end

  resources :raiders, only: [:index, :show, :new, :create, :update] do
    resources :attendances, only: [:index, :create, :destroy]
    resources :winners, only: [:index]
  end
  
  resources :raids, only: [:show, :create, :update, :destroy] do
    resources :signups, only: [:create, :destroy]
  end
  
  resources :news_posts, only: [:index, :show, :create, :update, :destroy] do
    resources :comments, only: [:create, :update, :destroy]
  end

  get '/user/index', to: 'users#index', as: 'user_index'
  get '/users/approve/:id', to: 'users#approve'
  get '/users/unapprove/:id', to: 'users#unapprove', as: 'user_unapprove'
  get '/users/raider/:id', to: 'users#raider', as: 'user_raider'
  get '/users/demote/:id', to: 'users#demote', as: 'user_demote'
  get '/users/admin/:id', to: 'users#admin', as: 'user_admin'
  get '/users/demote_admin/:id', to: 'users#demote_admin', as: 'user_demote_admin'
  get '/users/guild_master/:id', to: 'users#guild_master', as: 'user_guild_master'
  get '/users/demote_guild_master/:id', to: 'users#demote_guild_master', as: 'user_demote_guild_master'
  get '/users/:user_id/connect/:raider_id', to: 'users#connect'
  get '/search', to: 'pages#search', as: 'search_page'
  get '/raiders/:raider_id/search', to: 'raiders#search', as: 'raiders_search'
  get '/raiders/:raider_id/enchanted', to: 'raiders#enchanted', as: 'raiders_enchanted'
  get '/raiders/:raider_id/warlock', to: 'raiders#warlock', as: 'raiders_warlock'
  get '/calendar', to: 'pages#calendar'
  get '/zones/naxx', to: 'pages#naxx'
  get '/zones/aq', to: 'pages#aq'
  get '/zones/bwl', to: 'pages#bwl'
  get '/zones/mc', to: 'pages#mc'
  get '/zones/world_bosses', to: 'pages#world_bosses'
  get '/incomplete_items', to: 'pages#incomplete_items'
  get 'raiders/lock/:id', to: 'priorities#lock', as: 'raiders_lock'
  get 'raiders/unlock/:id', to: 'priorities#unlock', as: 'raiders_unlock'
end

Rails.application.routes.draw do

  root 'welcome#index'

  devise_for :users, :controllers => { :sessions => "sessions" }
  get '/share_my_path', :to => 'welcome#share_my_path'
  get '/auth/twitter/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  get '/auth/logout', :to => 'sessions#logout'
  get '/auth/destroy', :to => 'sessions#destroy'
  get '/twitter/update_all_users', :to => 'twitter#update_all_users'
  get '/twitter/update_current_user', :to => 'twitter#update_current_user'
  get '/twitter/', :to => 'twitter#index'
  get '/twitter/push_generic_message', :to => 'twitter#push_generic_message'
  #get '/users/:id', :to => 'users#show'

  resources :preferences
  resources :users              

end

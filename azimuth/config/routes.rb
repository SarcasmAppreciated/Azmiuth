Rails.application.routes.draw do
  devise_for :users, :controllers => { :sessions => "sessions" }
  get '/auth/twitter/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  get '/auth/logout', :to => 'sessions#logout'
  get '/auth/destroy', :to => 'sessions#destroy'
  get '/twitter/update_all_users', :to => 'twitter#update_all_users'
  get '/twitter/update_current_user', :to => 'twitter#update_current_user'
  get '/twitter/tweetview', :to => 'twitter#tweetview'
  get '/twitter/push_generic_message', :to => 'twitter#push_generic_message'
  resources :preferences

            

  root 'welcome#index'
end

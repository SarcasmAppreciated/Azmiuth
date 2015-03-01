Rails.application.routes.draw do
  devise_for :users, :controllers => { :sessions => "sessions" }
  #get   '/login', :to => 'sessions#new', :as => :login
  get '/auth/twitter/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  get '/auth/logout', :to => 'sessions#logout'
  get '/auth/destroy', :to => 'sessions#destroy'
  get '/twitter/tweetview', :to => 'twitter#tweetview'

  root 'welcome#index'
end

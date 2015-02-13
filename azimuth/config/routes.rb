Rails.application.routes.draw do
  devise_for :users
  #get   '/login', :to => 'sessions#new', :as => :login
  get '/auth/twitter/callback', :to => 'sessions#create'
  delete '/auth/failure', :to => 'sessions#failure'
  get '/logout', :to => 'sessions#destroy'
  get '/twitter/tweetview', :to => 'twitter#tweetview'

  root 'welcome#index'
end

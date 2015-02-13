Rails.application.routes.draw do
  devise_for :users
  get   '/login', :to => 'sessions#new', :as => :login
  get '/auth/twitter/callback', :to => 'sessions#create'
  delete '/auth/failure', :to => 'sessions#failure'

  root 'welcome#index'
end

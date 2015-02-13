Rails.application.routes.draw do
  get   '/login', :to => 'sessions#new', :as => :login
  post '/auth/:provider/callback', :to => 'sessions#create'
  delete '/auth/failure', :to => 'sessions#failure'

  root 'welcome#index'
end

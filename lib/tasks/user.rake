namespace :user do
  task user_update: :environment do
  	Tweet.update_all_users_aux
  end
end

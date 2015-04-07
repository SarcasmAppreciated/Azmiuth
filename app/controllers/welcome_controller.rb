require 'time'

class WelcomeController < ApplicationController
  helper_method :share_my_path
  before_action :set_users, only: [:index]
  
  def index
  end

  def user_signed_in
  	if current_user.nil?
  		return false
  	else 
  		return true
  	end
  end
  
  def share_my_path
     @user = current_user
    if @user 
      shareable_url = request.base_url+ "/users/" + @user.user_id.to_s
      twitter_share_message = "Look at my boat go! #AzimuthSailing " + shareable_url
       r = rand(1000)
      twitter_share_message += " " + r.to_s
      Tweet.pushTweet(@user, twitter_share_message)
    else 
      raise "User not signed in"
    end 
    redirect_to :root
  end

  private
    # NOTE: If testing this with a user other than user_1, please make sure
    #   that you run `rake user:user_update' to populate the database with
    #   each user's tweets!
    def set_users
       @users = []
      
      if user_signed_in
        @users << current_user.tweets(:sort){:time_stamp}
      else
        User.all.each do |user|
          @users << user.tweets(:sort){:time_stamp}
        end
      end
    end
  
end

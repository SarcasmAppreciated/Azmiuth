require 'time'

class WelcomeController < ApplicationController
  helper_method :share_my_path
  
  def index
    @user = current_user
    month = Date.today.strftime("%m")
    day = Date.today.strftime("%d")
    @icebergs = Iceberg.query_by_month_day(month, day)
    if user_signed_in
      @user_tweets = @user.tweets(:sort){:time_stamp}
    else
      @user_tweets = Tweet.none
    end
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
  
end

require 'time'

class WelcomeController < ApplicationController
  def index
    @user = current_user
    month = Date.today.strftime("%m")
    day = Date.today.strftime("%d")
    @icebergs = Iceberg.query_by_month_day(month, day)
    if user_signed_in
      @user_tweets = @user.tweets(:sort){:time_stamp}
    else
      @user_tweets = nil
    end
  end

  def user_signed_in
  	if current_user.nil?
  		return false
  	else 
  		return true
  	end
  end
  
end

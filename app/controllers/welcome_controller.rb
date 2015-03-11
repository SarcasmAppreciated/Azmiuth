class WelcomeController < ApplicationController
  def index
    @user = current_user
    month_day = Date.today.strftime("%d-%m")
    @icebergs = Iceberg.where("strftime('%d-%m', date) = ?", month_day)
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

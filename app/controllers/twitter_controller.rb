class TwitterController < ApplicationController
    require "twitter"

    @number_of_tweets_to_pull = 40

    def update_current_user
        update_current_user_aux
        redirect_to '/twitter/'
    end

    def update_current_user_aux
        user = current_user
        Tweet.update_user_tweets(user, @number_of_tweets_to_pull)
    end

    def update_all_users
        Tweet.update_all_users_aux
        redirect_to '/twitter/'
    end

    #Do not EVER send duplicate tweets! EVER!!! 
    #Twitter's API rules fobids sending duplicates
    def push_generic_message
        user = current_user
        message = "Hello #{user.name}! "
        #Twitter's API forbids sending duplicate tweets
        r = rand(10000)
        message += r.to_s
        Tweet.pushTweet(user, message)
        #############################
        #Code only used to seed database 
        # 
        #input_lat =  59.896510
        #input_long = -43.424513
        #Tweet.push_tweet_with_geo(user, message, input_lat, input_long)
        #Tweet.update_user_tweets(user,@number_of_tweets_to_pull)
        #############################
        redirect_to '/twitter/'
    end

	def index
		@user = current_user
        if !@user.nil?
            @user_tweets = @user.tweets(:sort){:time_stamp}
		else 
            puts "user not signed in"
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
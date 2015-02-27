class TwitterController < ApplicationController

	def tweetview
        require "twitter"

		@user = current_user
        if @user
    		@auth = @user.authorizations.first

            # Exchange our oauth_token and oauth_token secret for the AccessToken instance.
            
           
    		#response = access_token.request(:get, "https://api.twitter.com/1.1/statuses/home_timeline.json")
            #render :json => response.body
            @client = Twitter::REST::Client.new do |config|
                config.consumer_key = Rails.application.config.twitter_key
                config.consumer_secret = Rails.application.config.twitter_secret
                config.access_token = @auth['token']
                config.access_token_secret = @auth['secret']
            end

            #push a tweet
            #@client.update("gem auth PPATEN")

            #pull (the last) tweet
            response = @client.user_timeline({count: 1})
            @msg = response.first.text
            puts @msg
            #render :json => response


		else 
            @msg = "NoNoNo"
			puts @msg
		end

	end

end

#  config.consumer_key   = Rails.application.config.twitter_key
#config.consumer_secret     = Rails.application.config.twitter_secret
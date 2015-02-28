class TwitterController < ApplicationController

	def tweetview
        require "twitter"
		@user = current_user
        if @user

    		@auth = @user.authorizations.first
            
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
            @tweet_text = response.first.text
            @time_stamp = response.first.created_at
            @id = response.first.id

            #Get coordinates: NOTE THIS IS HIGHLY SENSITIVE USER OPTIONS
            #Likely need a more robust implementation to parsing geo data
            geo = response.first.geo.coordinates
            @lat = geo.first
            @long = geo.second


            
            #puts @tweet_text
            #puts @lat
            #puts @long
            #puts @time_stamp
            #puts @id

            @user.tweets.build :tweet_text => @tweet_text, :time_stamp => @time_stamp, :latitude => @lat, :longitude => @long, :tweet_id => @id
            @user.save
            #render :json => response
		else 
            @tweet_text = "None"
            @lat = "None"
            @long = "None"
            @time_stamp = "None"
            @id = "None"
			puts @tweet_text
		end
	end
end
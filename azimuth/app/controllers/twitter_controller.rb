class TwitterController < ApplicationController
    require "twitter"
    @@number_of_tweets_to_pull = 5

    def get_client(user)
        auth = user.authorizations.first
        client = Twitter::REST::Client.new do |config|
                config.consumer_key = Rails.application.config.twitter_key
                config.consumer_secret = Rails.application.config.twitter_secret
                config.access_token = auth['token']
                config.access_token_secret = auth['secret']
        end
        return client 
    end

    def pushTweet(user, message)
        client = get_client(user)
        client.update(message)
    end

    def pull_last_n_tweets(user, n)
        client = get_client(user)
        responses = client.user_timeline({count: n})
        return responses
    end

    def update_user_tweets(user, n)
        responses = pull_last_n_tweets(user,n)
        responses.each do |response|
            process_tweet(response, user)
        end
    end

    def update_current_user
        user = current_user
        update_user_tweets(user, @@number_of_tweets_to_pull)
        redirect_to '/twitter/tweetview'
    end

    def update_all_users
        User.all.each do |user|
            update_user_tweets(user, @@number_of_tweets_to_pull)
        end
       redirect_to '/twitter/tweetview'
    end

    #Do not EVER send duplicate tweets! EVER!!! 
    #Twitter's API rules fobids sending duplicates
    def push_generic_message
        user = current_user
        message = "Hello #{user.name}! "
        #Twitter's API forbids sending duplicate tweets
        r = rand(1000)
        message += r.to_s
        pushTweet(user, message)
        redirect_to '/twitter/tweetview'
    end

    def process_tweet(response, user)
        tweet_text = response.text
        time_stamp = response.created_at
        id = response.id
        geo = response.geo
        if !geo
            #will not process a tweet without a geoTag
            flash.now[:notice] = "no geotag for #{id}!"
            return
        end
        coordinates = geo.coordinates
        if !coordinates
            #will not process a tweet without a corrdinate
            flash.now[:notice] = "no coordinates for #{id}!"
            return
        end
        lat = coordinates.first
        long = coordinates.second
        user.tweets.build :tweet_text => tweet_text, :time_stamp => time_stamp, :latitude => lat, :longitude => long, :tweet_id => id
        user.save
        puts tweet_text
        flash.now[:notice] = "processed tweet #{id}!"
    end

	def tweetview
		@user = current_user
        if @user
            @user_tweets = @user.tweets(:sort){:time_stamp}
		else 
            puts "no no no"
		end
	end

    def user_signed_in
        if current_user
            return true
        else 
            return false
        end
  end
end
class Tweet < ActiveRecord::Base
	belongs_to :user
	validates :tweet_id, :time_stamp, :latitude, :longitude,  :presence => true 
	validates :tweet_id, uniqueness: true
	validates :latitude, :inclusion => -90..90
	validates :longitude, :inclusion => -180..180
end

@@number_of_tweets_to_pull = 25

public
	def update_all_users_aux
		puts "Updating Users"
		User.all.each do |user|
			puts "Updating User " + user.name
			update_user_tweets(user, @@number_of_tweets_to_pull)
		end
	end 

	def pushTweet(user, message)
        client = get_client(user)
        client.update(message)
    end

    #useless method meant to seed database
    def push_tweet_with_geo(user, message, input_lat, input_long)
        client = get_client(user)
        client.update(message, {:lat=> input_lat, :long=> input_long})
    end

   	def update_user_tweets(user, n)
		responses = pull_last_n_tweets(user,n)
		responses.each do |response|
			process_tweet(response, user)
		end
	end

private 
	def get_client(user)
		auth = user.authorization
		client = Twitter::REST::Client.new do |config|
			config.consumer_key = Rails.application.config.twitter_key
			config.consumer_secret = Rails.application.config.twitter_secret
			config.access_token = auth['token']
			config.access_token_secret = auth['secret']
		end
		return client 
	end

	def pull_last_n_tweets(user, n)
		client = get_client(user)
		responses = client.user_timeline({count: n})
		return responses
	end

	def process_tweet(response, user)
		tweet_text = response.text
		time_stamp = response.created_at
		id = response.id
		geo = response.geo
		if geo.nil?
            #will not process a tweet without a geoTag
            puts "no geotag for #{id}!"
            return
        end
        coordinates = geo.coordinates
        if coordinates.nil?
            #will not process a tweet without a corrdinate
            puts "no coordinates for #{id}!"
            return
        end
        lat = coordinates.first
        long = coordinates.second
        if lat.nil? or long.nil?
             #will not process a tweet without a lat/long
            puts "no lat/long for #{id}!"
            return 
        end
        user.tweets.build :tweet_text => tweet_text, :time_stamp => time_stamp, :latitude => lat, :longitude => long, :tweet_id => id
        user.save
        puts tweet_text
        puts "processed tweet #{id}!"
    end
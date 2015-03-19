class Tweet < ActiveRecord::Base
	belongs_to :user
	validates :tweet_id, :time_stamp, :latitude, :longitude,  :presence => true 
	validates :tweet_id, uniqueness: true
	validates :latitude, :inclusion => -90..90
	validates :longitude, :inclusion => -180..180


end

public
	def update_all_users_aux
		User.all.each do |user|
			update_user_tweets(user, 25)
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

	def update_user_tweets(user, n)
		responses = pull_last_n_tweets(user,n)
		responses.each do |response|
			process_tweet(response, user)
		end
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
            #flash.now[:notice] = "no geotag for #{id}!"
            return
        end
        coordinates = geo.coordinates
        if coordinates.nil?
            #will not process a tweet without a corrdinate
            #flash.now[:notice] = "no coordinates for #{id}!"
            return
        end
        lat = coordinates.first
        long = coordinates.second
        if lat.nil? or long.nil?
             #will not process a tweet without a lat/long
            #flash.now[:notice] = "no lat/long for #{id}!"
            return 
        end
        user.tweets.build :tweet_text => tweet_text, :time_stamp => time_stamp, :latitude => lat, :longitude => long, :tweet_id => id
        user.save
        puts tweet_text
        #flash.now[:notice] = "processed tweet #{id}!"
    end
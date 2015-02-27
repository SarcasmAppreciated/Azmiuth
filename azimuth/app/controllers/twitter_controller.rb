class TwitterController < ApplicationController

	def tweetview
		# def prepare_access_token(oauth_token, oauth_token_secret)
  #           oauth_token = 
  #           oauth_token_secret = 
  #           consumer = OAuth::Consumer.new("APIKey", "APISecret"
  #               { :site => "http://api.twitter.com"
  #               })
  #           # now create the access token object from passed values
  #           token_hash = { :oauth_token => oauth_token,
  #                                        :oauth_token_secret => oauth_token_secret
  #                                    }
  #           access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
  #           return access_token
  #       end

		@user = current_user
		@auth = @user.authorizations.first
		if @user
			puts "#{@auth.secret}"
		else 
			puts "NoNoNo"
		end
	end

end
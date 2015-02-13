class TwitterController < ApplicationController

	def tweetview
	end

end


rails generate model Tweet user:string text:string twitter_created_at:datetime
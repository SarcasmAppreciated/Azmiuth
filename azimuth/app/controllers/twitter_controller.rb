class TwitterController < ApplicationController

	def tweetview
		user = current_user
		if user
			puts "Hahaha"
		else 
			puts "NoNoNo"
		end
	end

end



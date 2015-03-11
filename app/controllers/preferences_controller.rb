class PreferencesController < ApplicationController
	def index
		@user = current_user
		if @user
			@preference = @user.preference
		end
	end

	def update
		@destination_latitude = Float(params["preference"]["destination_latitude"]) rescue false
		@destination_longitude = Float(params["preference"]["destination_longitude"]) rescue false
		if @destination_latitude and @destination_longitude
			@user = current_user
			@preference = @user.preference
			@preference["destination_latitude"] = @destination_latitude
			@preference["destination_longitude"]= @destination_longitude
			@preference.save
			redirect_to action: :index
		else
			redirect_to action: :index
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

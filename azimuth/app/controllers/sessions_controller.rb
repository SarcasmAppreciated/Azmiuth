class SessionsController < ApplicationController
  

  def create

  	auth_hash = request.env['omniauth.auth']

	@authorization = Authorization.find_by_provider_and_uid("twitter", auth_hash["uid"])
	if @authorization
		@user = @authorization.user
		render :text => "Welcome back #{@authorization.user.name}! You have already signed up."
	else
		#user = User.new :name => auth_hash["user_info"]["name"], :email => auth_hash["user_info"]["email"]
		#user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
		#user.save

		@user = User.new :name => auth_hash["info"]["name"], :email =>  "default@mail.com"
		@user.password = "password"

		@user.authorizations.build :provider => "twitter", :uid => auth_hash["uid"]
		@user.save
		@user.errors.each do |error|
			puts error
		end


		render :text => "Hi #{@user.name}! You've signed up."
	end
  end

  def failure
  end

end

class SessionsController < ApplicationController
  

  def create

  	auth_hash = request.env['omniauth.auth']

	@authorization = Authorization.find_by_provider_and_uid("twitter", auth_hash["uid"])
	if @authorization
		@user = @authorization.user
		#redirect_to root
		flash.now[:notice] = "Welcome back #{@authorization.user.name}! You have already signed up."
		sign_in_and_redirect(:user, @user)
		
		#redirect_to '/twitter/tweetview'
		#render :text => "Welcome back #{@authorization.user.name}! You have already signed up."
	else
		#user = User.new :name => auth_hash["user_info"]["name"], :email => auth_hash["user_info"]["email"]
		#user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
		#user.save

		@user = User.new :name => auth_hash["info"]["name"], :email =>  "default@mail.com"
		@user.password = "password"
		@user.authorizations.build :provider => "twitter", :uid => auth_hash["uid"], :secret => auth_hash['credentials']['secret'], :token => auth_hash['credentials']['token']
		@user.save
		@user.errors.each do |error|
			puts error
		end

		flash.now[:notice] = "Hi #{@user.name}! You've signed up."
		sign_in_and_redirect(:user, @user)
		#render :text => "Hi #{@user.name}! You've signed up."
	end
  end


  def logout
  	@user = current_user
  	sign_out_and_redirect(@user)
  end

  def failure
  	render :text => "Sorry, but you didn't allow access to our app!"
  end

  def destroy
  	@user = current_user
  	@user.destroy
  	render :text => "profile deleted."
  end

end

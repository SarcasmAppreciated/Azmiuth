class SessionsController < ApplicationController
  

  def create
    auth_hash = request.env['omniauth.auth']
    @user = User.find_by_user_id(auth_hash["uid"])
  	if @user
  		@authorization = @user.authorization
  		flash.now[:notice] = "Welcome back #{@user.name}! You have already signed up."
      session[:user_id] = auth_hash["uid"].to_i 
  	else
  		@user = User.new :name => auth_hash["info"]["name"], :user_name => auth_hash["info"]["nickname"], :user_id => auth_hash["uid"], :profile_image_url => auth_hash["info"]["image"].sub("_normal", "")
      @user.build_authorization :secret => auth_hash['credentials']['secret'], :token => auth_hash['credentials']['token']
      @user.build_preference 
  		@user.save!
  		@user.errors.each do |error|
  			puts error
  	end
  		flash.now[:notice] = "Hi #{@user.name}! You've signed up."
      session[:user_id] = auth_hash["uid"].to_i
    end
      redirect_to :root
  end
  
  def logout
    session[:user_id] = nil
    redirect_to :root
  end

  def failure
  	render :text => "Sorry, but you didn't allow access to our app!"
  end

  def destroy
  	@user = current_user
  	if @user
  		@user.destroy
  	end
    redirect_to :root
  end

end

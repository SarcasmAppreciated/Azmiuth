class WelcomeController < ApplicationController
  def index
  end

  def user_signed_in
  	if current_user.nil?
  		return false
  	else 
  		return true
  	end
  end
end

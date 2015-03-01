class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
  	puts "***********************************"
  	puts session[:uid]
  	puts "***********************************"
  	return User.find_by_uid(session[:uid])
  end
  

end

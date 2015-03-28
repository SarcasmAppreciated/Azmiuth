require 'time'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :load_icebergs

  def current_user
  	return User.find_by_user_id(session[:user_id])
  end

  def load_icebergs
  	month = Date.today.strftime("%m")
    day = Date.today.strftime("%d")
    @icebergs = Iceberg.query_by_month_day(month, day)
  end

   
end

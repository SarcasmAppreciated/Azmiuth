require 'time'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :load_icebergs
  before_filter :redirect_to_azimuthsail if Rails.env.production?

  def current_user
  	return User.find_by_user_id(session[:user_id])
  end

  def load_icebergs
  	month = Date.today.strftime("%m")
    day = Date.today.strftime("%d")
    @icebergs = Iceberg.query_by_month_day(month, day)
    if @icebergs.empty?
      @icebergs = Iceberg.query_by_month_day('04', '20')
    end
  end

  def redirect_to_azimuthsail
    domain_to_redirect_to = 'www.azimuthsail.com'
    domain_to_catch = 'sheltered-stream-7018.herokuapp.com'
    should_redirect = request.host.include? domain_to_catch
    new_url = "#{request.protocol}#{domain_to_redirect_to}#{request.fullpath if request.fullpath != '/'}"
    redirect_to new_url, status: :moved_permanently if should_redirect
  end



   
end

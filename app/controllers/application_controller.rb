#base application controller which the others are "extending" from
class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user

  #require user to be logged per default (exceptions can be made)
  def require_login
    redirect_to new_session_path unless session.include? :user_id
  end

  #set current user (if logged in)
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end

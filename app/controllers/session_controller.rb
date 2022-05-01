# controller used for session management
class SessionController < ApplicationController

  # skip the login requirement since SessionController#create is used to Login a (registered) user
  # # and must therefore be accessible for not logged in users
  skip_before_action :require_login, only: [:create, :new]

  #create new user
  def new
    @user = User.new
  end

  #  session (=login user) if username,password matches a db entry (i.e. if the user is registered) and set according flash
  def create
    session_params = params.require(:user).permit(:username, :password)
    @user = User.find_by(username: session_params[:username])
    if @user && @user.password == session_params[:password]
      session[:user_id] = @user.id
      redirect_to @user
    else
      flash[:notice] = "Login is invalid!"
      redirect_to new_session_path
    end
  end

  # Destroy session (=logout user) and set according flash
  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been signed out!"
    redirect_to new_session_path
  end
end

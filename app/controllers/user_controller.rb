# UserController is the controller handling user management (registration of new users, rendering user profile page)
class UserController < ApplicationController

    # Skip the login requirement since UserController#create is used to register a new user
    # and must therefore be accessible for not logged in users
    skip_before_action :require_login, only: [:new,:create]

    # User registration
    def new
        @user = User.new
    end

    # Renders the currently logged in user's profile page
    def show
        @user = User.find_by(id: session[:user_id])
    end

    # POST endpoint which the data of the user registration form is POSTed to
    # inputs are validated by user_controller#user_params
    def create
        @user = User.new(user_params)
        if user_params[:password] != user_params[:password_confirmation] # check if both given passwords match
            flash[:notice] = "Passwords did not match"
            redirect_to new_user_path
        elsif User.find_by(username: @user.username) # check if username is already taken
            flash[:notice] = "Username already taken!"
            redirect_to new_user_path
        elsif @user.save # try to persist new user
            flash[:notice] = "Registration successful! Login in now!"
            redirect_to new_session_path
        else # something went wrong persisting
            flash[:notice] = "Error persisting new user"
            redirect_to new_user_path
        end
    end

    def destroy
    end

    private

    # validation of form input
    def user_params
        params.require(:user).permit(:username, :password, :password_confirmation)
    end
end

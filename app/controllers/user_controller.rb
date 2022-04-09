class UserController < ApplicationController
    skip_before_action :require_login, only: [:new,:create]

    def new
        @user = User.new
    end

    def show
        @user = User.find_by(id: session[:user_id])
    end

    def create
        @user = User.new(user_params)
        if user_params[:password] != user_params[:password_confirmation]
            flash[:notice] = "Passwords did not match"
            redirect_to new_user_path
        elsif User.find_by(username: @user.username)
            flash[:notice] = "Username already taken!"
            redirect_to new_user_path
        elsif @user.save
            flash[:notice] = "Registration successful! Login in now!"
            redirect_to new_session_path
        else
            flash[:notice] = "Error persisting new user"
            redirect_to new_user_path
        end
    end

    def destroy
    end

    private
    def user_params
        params.require(:user).permit(:username, :password, :password_confirmation)
    end
end

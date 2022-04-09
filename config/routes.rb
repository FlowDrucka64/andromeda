Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "user#show"
  resources :user, only: [:new, :create, :index, :show]
  resources :session, only: [:new, :create, :destroy]

  post "login", to:"session#create", as:"login"
  post "register", to:"user#create", as:"register"

  delete "logout", to:"session#destroy", as:"logout"

end

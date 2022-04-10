Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "user#show"
  resources :user, only: [:new, :create, :index, :show]
  resources :session, only: [:new, :create, :destroy]

  post "login", to: "session#create", as: "login"
  post "register", to: "user#create", as: "register"
  delete "logout", to: "session#destroy", as: "logout"

  get "staff/search", to: "staff#search", as: "staff/search"
  post "staff/query", to: "staff#query", as: "staff/query"
  get "staff/favourites", to: "staff#favourites", as: "staff/favourites"

  get "course/search", to: "course#search", as: "course/search"
  post "course/query", to: "course#query", as: "course/query"
  get "course/favourites", to: "course#favourites", as: "course/favourites"

  get "project/search", to: "project#search", as: "project/search"
  post "project/query", to: "project#query", as: "project/query"
  get "project/favourites", to: "project#favourites", as: "project/favourites"

  get "thesis/search", to: "thesis#search", as: "thesis/search"
  post "thesis/query", to: "thesis#query", as: "thesis/query"
  get "thesis/favourites", to: "thesis#favourites", as: "thesis/favourites"

end

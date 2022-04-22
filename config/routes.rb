Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "user#show"
  resources :user, only: [:new, :create, :index, :show]
  resources :session, only: [:new, :create, :destroy]

  post "login", to: "session#create", as: "login"
  post "register", to: "user#create", as: "register"
  get "logout", to: "session#destroy", as: "logout"

  get "staff/search", to: "staff#search", as: "staff/search"
  post "staff/query", to: "staff#query", as: "staff/query"
  get "staff/favourites", to: "staff#favourites", as: "staff/favourites"
  get "staff/detail/:id", to: "staff#detail", as: "staff/detail"
  post "staff/create", to: "staff#create", as: "staff/create"
  get "staff/edit", to: "staff#edit", as: "staff/edit"
  post "staff/update", to: "staff#update", as: "staff/update"
  get "staff/destroy", to: "staff#destroy", as: "staff/destroy"

  get "course/search", to: "course#search", as: "course/search"
  post "course/query", to: "course#query", as: "course/query"
  get "course/favourites", to: "course#favourites", as: "course/favourites"
  get "course/detail/:id", to: "course#detail", as: "course/detail"

  get "project/search", to: "project#search", as: "project/search"
  post "project/query", to: "project#query", as: "project/query"
  get "project/favourites", to: "project#favourites", as: "project/favourites"
  get "project/detail/:id", to: "project#detail", as: "project/detail"

  get "thesis/search", to: "thesis#search", as: "thesis/search"
  post "thesis/query", to: "thesis#query", as: "thesis/query"
  get "thesis/favourites", to: "thesis#favourites", as: "thesis/favourites"
  get "thesis/detail/:id", to: "thesis#detail", as: "thesis/detail"

end

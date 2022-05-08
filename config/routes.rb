Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "user#show"
  resources :user, only: [:new, :create, :index, :show]
  resources :session, only: [:new, :create, :destroy]

  #Session management
  post "login", to: "session#create", as: "login"
  post "register", to: "user#create", as: "register"
  get "logout", to: "session#destroy", as: "logout"

  #Staff functionalities
  get "staff/search", to: "staff#search", as: "staff/search"
  post "staff/query", to: "staff#query", as: "staff/query"
  get "staff/favourites", to: "staff#favourites", as: "staff/favourites"
  get "staff/detail/:id", to: "staff#detail", as: "staff/detail"
  post "staff/create", to: "staff#create", as: "staff/create"
  get "staff/edit", to: "staff#edit", as: "staff/edit"
  post "staff/update", to: "staff#update", as: "staff/update"
  get "staff/destroy", to: "staff#destroy", as: "staff/destroy"

  #Course functionalities
  get "course/search", to: "course#search", as: "course/search"
  post "course/query", to: "course#query", as: "course/query"
  get "course/favourites", to: "course#favourites", as: "course/favourites"
  get "course/detail/:id", to: "course#detail", as: "course/detail"
  post "course/create", to: "course#create", as: "course/create"
  get "course/edit", to: "course#edit", as: "course/edit"
  post "course/update", to: "course#update", as: "course/update"
  get "course/destroy", to: "course#destroy", as: "course/destroy"

  #Project functionalities
  get "project/search", to: "project#search", as: "project/search"
  post "project/query", to: "project#query", as: "project/query"
  get "project/favourites", to: "project#favourites", as: "project/favourites"
  get "project/detail/:id", to: "project#detail", as: "project/detail"

  #Thesis functionalities
  get "thesis/search", to: "thesis#search", as: "thesis/search"
  post "thesis/query", to: "thesis#query", as: "thesis/query"
  get "thesis/favourites", to: "thesis#favourites", as: "thesis/favourites"
  get "thesis/detail/:id", to: "thesis#detail", as: "thesis/detail"

end

Rails.application.routes.draw do
  root to: "trips#index"

  get '/trips',         to: 'trips#index',         as: 'trips'
  get '/about',          to: 'pages#about',          as: 'about'
  get '/contact',        to: 'pages#contact',        as: 'contact'
  get '/privacy_policy', to: 'pages#privacy_policy', as: 'privacy_policy'
  get '/search_users', to: 'users#search_users'
  # Additional routes...

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  # Defines the root path route ("/")
  # root "posts#index"
  resources :users, only: [:show, :edit, :update, :index]
  resources :preferences, only: [:new, :create]

  resources :trips, only: [:new, :create, :show] do # location/budget/dates
    resources :trip_activities, only: [:create]
  end
  resources :trip_activities, only:[:destroy]
  resources :activities do
    resources :activity_reviews, only: [:create]
  end
end

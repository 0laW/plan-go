Rails.application.routes.draw do
  root to: "trips#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :users, only: [:show, :edit, :update] do
    resources :preferences, only: [:create]
  end

  resources :trips, only: [:create] do # location/budget/dates
    resources :trip_users  # people going on the trip
    resources :trip_activities  # itinerary
  end

  resources :activities, only: [:show] # activities that will be in the itinerary
  resources :activity_reviews, only: [:create]
end

devise_for :users

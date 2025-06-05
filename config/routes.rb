Rails.application.routes.draw do

  get 'onboarding/steps(/:step)', to: 'onboarding#steps', as: :onboarding_steps
  post 'onboarding/save_interests',   to: 'onboarding#save_interests'

  post 'onboarding/save_sub_interests', to: 'onboarding#save_sub_interests'

  post 'onboarding/save_style_and_personality', to: 'onboarding#save_style_and_personality'

  post 'onboarding/friends/search',    to: 'onboarding#find_friends',  as: :onboarding_find_friends
  post 'onboarding/save_friends', to: 'onboarding#save_friends'
  get "search_users", to: "users#search_users"

  post 'onboarding/complete',         to: 'onboarding#complete'

  root to: "trips#index"

  get '/trips',         to: 'trips#index',         as: 'trips'
  get '/about',          to: 'pages#about',          as: 'about'
  get '/contact',        to: 'pages#contact',        as: 'contact'
  get '/privacy_policy', to: 'pages#privacy_policy', as: 'privacy_policy'
  get "search_users", to: "users#search_users"
  get "users/search_users", to: "users#search_users"
  get "search", to: "search#index", as: :search


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

  resources :activities

  resources :friendships, only: [:create, :update]
  resources :feedbacks, only: [:create]

  resources :trip_users, only: [:create]

  resources :trips, only: [:new, :create, :show] do # location/budget/dates
    resources :trip_activities, only: [:create]
    member do
    delete 'remove_user', to: 'trips#remove_user'
   end
  end
  resources :trip_activities, only:[:destroy]
  resources :activities do
    resources :activity_reviews, only: [:create]
  end
end

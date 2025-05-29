Rails.application.routes.draw do

  get  'onboarding/welcome',          to: 'onboarding#welcome'
  get  'onboarding/interests',        to: 'onboarding#interests'
  post 'onboarding/save_interests',   to: 'onboarding#save_interests'

  get  'onboarding/sub_interests',    to: 'onboarding#sub_interests'
  post 'onboarding/save_sub_interests', to: 'onboarding#save_sub_interests'

  get  'onboarding/style_and_personality', to: 'onboarding#style_and_personality'
  post 'onboarding/save_style_and_personality', to: 'onboarding#save_style_and_personality'

  get  'onboarding/friends',           to: 'onboarding#friends',       as: :onboarding_friends
  post 'onboarding/friends/search',    to: 'onboarding#find_friends',  as: :onboarding_find_friends

  get  'onboarding/complete',         to: 'onboarding#complete'
  post 'onboarding/complete',         to: 'onboarding#complete'       # to handle form submission on last step

  root to: "trips#index"

  get '/trips',         to: 'trips#index',         as: 'trips'
  get '/about',          to: 'pages#about',          as: 'about'
  get '/contact',        to: 'pages#contact',        as: 'contact'
  get '/privacy_policy', to: 'pages#privacy_policy', as: 'privacy_policy'
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

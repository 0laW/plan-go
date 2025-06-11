Rails.application.routes.draw do
  get 'notifications/index'

get  '/onboarding/welcome',               to: 'onboarding#welcome',               as: 'onboarding_welcome'
get  '/onboarding/interests',             to: 'onboarding#interests',             as: 'onboarding_interests'
post '/onboarding/save_interests',        to: 'onboarding#save_interests',        as: 'onboarding_save_interests'   # <-- POST here
get  '/onboarding/sub_interests',         to: 'onboarding#sub_interests',         as: 'onboarding_sub_interests'
post '/onboarding/save_sub_interests',    to: 'onboarding#save_sub_interests',    as: 'onboarding_save_sub_interests'
get  '/onboarding/style_and_personality', to: 'onboarding#style_and_personality', as: 'onboarding_style_and_personality'
post '/onboarding/save_style_and_personality', to: 'onboarding#save_style_and_personality', as: 'onboarding_save_style_and_personality'
get  '/onboarding/complete',               to: 'onboarding#complete',               as: 'onboarding_complete'

  root to: "trips#index"

  get '/trips',         to: 'trips#index',         as: 'trips'
  get '/about',         to: 'pages#about',         as: 'about'
  get '/contact',       to: 'pages#contact',       as: 'contact'
  get '/privacy_policy',to: 'pages#privacy_policy',as: 'privacy_policy'
  get "search_users",   to: "users#search_users"
  get "users/search_users", to: "users#search_users"
  get "search",         to: "search#index",        as: :search


  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  resources :users, only: [:show, :edit, :update, :index]
  resources :preferences, only: [:new, :create]

  resources :activities

  resources :friendships, only: [:create, :update]
  resources :feedbacks, only: [:create]

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end

  resources :trip_users, only: [:create]

  resources :trips, only: [:new, :create, :show] do
    resources :trip_activities, only: [:create]
    member do
      delete 'remove_user', to: 'trips#remove_user'
    end
  end

  resources :trip_activities, only: [:destroy]

  resources :activities do
    resources :activity_reviews, only: [:create]
  end
end

# frozen_string_literal: true

Rails.application.routes.draw do
  root 'signin#show'
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
  get 'signin', to: 'signin#show', as: 'signin'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'register', to: 'register#show', as: 'register'
  get 'google_login', to: redirect('/auth/google_oauth2'), as: 'google_login'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'home', to: 'home#show'
  get 'rewards', to: 'rewards#index', as: 'rewards'
  get 'eligible_rewards', to: 'rewards#eligible', as: 'eligible_rewards'
  get 'events', to: 'events#index', as: 'events'
  get 'my_events', to: 'events#my_events', as: 'my_events'
  get 'delete_all_users_warning', to: 'users#delete_all_users_warning', as: 'delete_all_users_warning'
  get 'delete_all_users', to: 'users#delete_all_users', as: 'delete_all_users'
  get 'delete_rewards_warning', to: 'rewards#delete_rewards_warning', as: 'delete_rewards_warning'
  get 'delete_rewards', to: 'rewards#delete_rewards', as: 'delete_rewards'

  # get 'me', to: 'me#show', as: 'me'

  post 'default_login', to: 'sessions#default_create', as: 'default_login'
  post 'attempt_register', to: 'sessions#register_create', as: 'attempt_register'

  resources :users do
    member do
      get :delete
    end
  end

  resources :events do
    member do
      get :delete
    end
  end

  resources :rewards do
    member do
      get :delete
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

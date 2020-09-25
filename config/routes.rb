Rails.application.routes.draw do

  get 'dashboard/index'
  get 'signin', to: 'signin#show', as: 'signin'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'register', to: 'register#show', as: 'register'
  get 'google_login', to: redirect('/auth/google_oauth2'), as: 'google_login'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'home', to: 'home#show'
  get 'me', to: 'me#show', as: 'me'
  
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

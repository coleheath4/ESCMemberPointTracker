Rails.application.routes.draw do

  get 'google_login', to: redirect('/auth/google_oauth2'), as: 'google_login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'home', to: 'home#show'
  get 'me', to: 'me#show', as: 'me'
  get 'signin', to: 'signin#show', as: 'signin'
  
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

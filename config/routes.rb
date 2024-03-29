Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  # mount Ahoy::Engine, at: "/ahoy"

  resources :users
  
  resources :pdfs, param: :id do
    member do
      put 'unblur'
      put 'unlock_pdf'
    end
  end

  # resources :pdfs

  root to: 'home#index'

  get '/search', to: 'search#index', as: 'search'

end
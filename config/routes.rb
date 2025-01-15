Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  post 'register', to: 'users#register'
  post 'login', to: 'users#login'
  get 'users/:id', to: 'users#show'
  resources :posts

  resources :posts do
    resources :comments, only: [:create, :index]
  end
end

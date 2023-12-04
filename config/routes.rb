Rails.application.routes.draw do
  devise_for :users#, controllers: { sessions: 'users/sessions' }

  root to: 'restaurants#index'

  devise_scope :user do
    get 'users/sign_out', to: 'devise/sessions#destroy'
  end


  # post 'users/forgot_password', to: 'users#forgot_password'
  # post 'users/reset_password', to: 'users#reset_password'
  # post "user_login", to: "users#user_login"
  get "dishes/search", to: "dishes#search"
  resource :users#, only: [:create,:show,:update,:destroy]
  resources :restaurants do
    resources :dishes
  end
  resources :categories#, only: [:index, :new, :create,:show,:update]
  resources :carts #, only: [:create]
  resources :cart_items#, only: [:index, :create, :update, :destroy]
  resources :orders, only: [:index, :create, :show, :destroy]
end

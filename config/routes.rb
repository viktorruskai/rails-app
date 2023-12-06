Rails.application.routes.draw do
  root 'static_pages#home'

  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/new-admin', to: 'users#new_admin'
  post '/new-admin', to: 'users#create_admin'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :videos, only: [:index, :edit, :update, :new, :show, :create, :destroy]
  resources :video_notes, only: [:create, :edit, :update, :destroy]
end

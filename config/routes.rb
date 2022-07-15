Rails.application.routes.draw do

  get 'favorites/create'
  get 'favorites/destroy'
  get "users/:id/followings" => "users#followings"
  get "users/:id/followers" => "users#followers"
  devise_for :users
  get "users/favorite_index/:id" =>"users#favorite_index"
  delete 'users/:id' => 'users#destroy'
  resources :users, only: [:show,:index]
  
  get "home/top" => "home#top"
  get "home/about" => "home#about"
  get "home/thanks" => "home#thanks"

  get 'posts/new' => 'posts#new'
  root "posts#index"
  get 'posts/:id' => 'posts#show',as: 'post'
  patch 'posts/:id' => 'posts#update'
  delete 'posts/:id' => 'posts#destroy'
  get 'posts/:id/edit' => 'posts#edit', as:'edit_post'
  post 'posts' => 'posts#create'

  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create]
    resource :favorites, only: [:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

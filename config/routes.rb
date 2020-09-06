Rails.application.routes.draw do
get "search" => "search#search"

  devise_for :users
  root 'home#top'
  get 'home/about'
  resources :users, only: [:show, :index, :edit, :update]do
    resource :relationships, only: [:create, :destroy]
    get :follows, on: :member # 追加
    get :followers, on: :member # 追加
  end
  resources :books, except: [:new] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
end

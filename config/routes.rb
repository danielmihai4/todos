Rails.application.routes.draw do

  post 'toggle_item_state/:id/:state', to: 'items#toggle_state'

  devise_for :users, :controllers => {:registrations => "user/registrations"}
  resources :friendships
  resources :users, only: [:show]
  resources :lists do
    resources :items

  end

  root 'pages#home'
  get 'my_friends', to: 'users#my_friends'
  get 'search_friends', to: 'users#search'
  post 'add_friend', to: 'users#add_friend'
end

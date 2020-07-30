Rails.application.routes.draw do
  get '/users/stay_logged_in', to: 'users#stay_logged_in'
  patch 'users/:id', to:'users#update'
  patch '/check_price', to:'portfolio_lists#check_price'
  resources :portfolio_lists
  resources :stocks
  resources :users

  post '/login', to: 'users#login'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

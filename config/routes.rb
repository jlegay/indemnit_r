Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'surveys#show'

  resources :surveys, only: [:show]

  resources :questions, only: [:show]

  resources :results, only: [:show]

  get 'airports_distance', to: 'airports#airports_distance'
  get 'no_indemnities', to: 'pages#no_indemnities'
  post 'indemnities_amount', to: 'pages#indemnities_amount'
end

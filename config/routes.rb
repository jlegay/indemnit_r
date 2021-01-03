Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#home'

  resources :surveys, only: [:show]

  resources :questions, only: [:show]

  get 'flight_details', to: 'pages#flight_details'
  get 'no_indemnities', to: 'pages#no_indemnities'
  get 'display_indemnities', to: 'pages#display_indemnities'
  post 'indemnities_amount', to: 'pages#indemnities_amount'
end

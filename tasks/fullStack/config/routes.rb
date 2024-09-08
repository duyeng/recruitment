require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app

  resources :reviews, only: [:index, :create, :new] do
  end

  get 'reviews/list_by_product', to: 'reviews#list_by_product'
end

Rails.application.routes.draw do

  get 'errors/routing_error'
  root 'tasks#index'
  resources :tasks, only: [:index,:new, :create, :edit, :show, :update,:destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :labels, only: [:index, :new, :create, :edit,:update, :destroy ]

  namespace :admin do
    resources :users, only: [:index, :new,:show, :create, :edit, :update, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #match "/404", to: "errors#not_found", via: :all
  #match "/500", to: "errors#internal_server_error", via: :all
end

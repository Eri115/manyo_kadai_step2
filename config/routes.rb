Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks, only: [:index,:new, :create, :edit, :show, :update,:destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  namespace :admin do
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

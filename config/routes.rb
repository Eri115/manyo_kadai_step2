Rails.application.routes.draw do
  get 'labels/index'
  get 'labels/new'
  get 'labels/create'
  get 'labels/edit'
  root 'tasks#index'
  resources :tasks, only: [:index,:new, :create, :edit, :show, :update,:destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :labels, only: [:index, :new, :create, :edit,:update, :destroy ]

  namespace :admin do
    resources :users, only: [:index, :new,:show, :create, :edit, :update, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

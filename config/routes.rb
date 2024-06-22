Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks, only: [:index,:new, :create, :edit, :show, :update,:destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

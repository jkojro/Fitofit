Rails.application.routes.draw do
  devise_for :users
  resources :walks, only: [:new, :create, :show, :index]
  root 'walks#new'
end

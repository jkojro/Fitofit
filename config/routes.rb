Rails.application.routes.draw do
  resources :walks, only: [:new, :create, :show]
  root 'walks#new'
end

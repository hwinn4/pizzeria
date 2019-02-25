Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :orders, only: [:create, :index, :show]
    resources :pizzas, only: [:index]
  end
end

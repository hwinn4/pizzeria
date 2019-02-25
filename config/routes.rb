Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    # TODO: Why nested under /api?
    resources :orders, only: [:create, :index]
    resources :pizzas, only: [:index]
  end
end

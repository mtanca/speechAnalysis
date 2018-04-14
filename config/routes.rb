Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "user/registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "profile#index"
  get "/profile", to:"profile#index"
  get "/profile/history", to:"profile#history"
  get "/profile/history/:id", to: "profile#record"

  resources :users, only: [] do
    resources :speech_results, only: [:index, :show, :create]
    resources :interim_results, only: [:create]
  end

  get '*unmatched_route', to: 'application#not_found'

  post "/static" => "static#create"
end

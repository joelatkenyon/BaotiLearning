Rails.application.routes.draw do
  resources :tasks
  resources :buckets
  devise_for :users

  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # Set root to courses index since it's the main feature of our app
  root "courses#index"
  # Triple nest resources to create the desired database hierarchy
  resources :courses do
    resources :sections do
      resources :assignments
    end
  end
  
  # Route a non-RESTful route, enroll
  get 'courses/:id/enroll', to: 'courses#enroll', as: :enroll
end

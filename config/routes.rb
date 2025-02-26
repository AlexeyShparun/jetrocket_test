Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts, only: [] do
        collection do
          post :create       # POST /api/v1/posts
          get :top           # GET /api/v1/posts/top?n=5
          get :ip_list       # GET /api/v1/posts/ip_list
        end
      end

      resources :ratings, only: [ :create ] # POST /api/v1/ratings
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

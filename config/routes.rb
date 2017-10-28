Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    resources :predictions, only: [ :index, :create, :show, :destroy ]
  end

  authenticated :user do
    root to: 'predictions#index'
  end

  unauthenticated do
    root to: 'pages#home'
  end

  namespace :api do
    namespace :v1 do
      resources :predictions, only: :show
    end
  end
end

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
end

Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    resources :predictions, only: [ :index, :create, :show, :destroy ]
  end

  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

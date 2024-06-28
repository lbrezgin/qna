Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :users, shallow: true do
    resources :questions, shallow: true do
      resources :answers, only: [:show, :new, :create, :destroy]
    end
  end
end

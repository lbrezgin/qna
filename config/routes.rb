Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :users, shallow: true do
    resources :questions, shallow: true do
      resources :answers, shallow: true
    end
  end
end

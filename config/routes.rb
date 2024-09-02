Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      post :like
      post :dislike
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :users, shallow: true do
    resources :questions, concerns: [:votable, :commentable], shallow: true do
      resources :answers, concerns: [:votable, :commentable], shallow: true do
        member do
          patch :mark_as_best
        end
      end
    end
    resources :rewards, only: [:index]
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]

  mount ActionCable.server => '/cable'
end


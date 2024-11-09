require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    post '/authorizations', to: 'oauth_callbacks#create_authorization'
  end

  root to: "questions#index"

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, except: [:new, :edit], shallow: true do
        resources :answers, except: [:new, :edit]
      end
    end
  end

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
      resources :subscriptions, only: [:create, :destroy], shallow: true do
      end

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

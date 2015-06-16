require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post '/finish_sign_up' => 'omniauth_callbacks#finish_sign_up'
  end

  resources :attachments, only: [:destroy]

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :unvote
    end
  end

  concern :commentable do |options|
    resources :comments, options
  end

  resources :questions, concerns: :votable  do
    concerns :commentable, only: :create, defaults: { commentable: 'questions' }
    resources :subscriptions, only: [:create, :destroy]
    resources :answers, only: [:create, :update, :destroy], concerns: :votable, shallow: true do
      concerns :commentable, only: :create, defaults: { commentable: 'answers' }
      member { patch :set_the_best }
    end
  end

  match 'search', to: 'search#search', via: :get, as: :search

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create]
      end
    end
  end
end

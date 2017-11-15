Rails.application.routes.draw do

  root 'activities#index'
  get '/about' => 'static_pages#about'
  get '/how-to' => 'static_pages#how_to'
  get '/.well-known/acme-challenge/:id' => 'static_pages#lets_encrypt'

  devise_for :users, :controllers => { :omniauth_callbacks => 'auth/omniauth_callbacks' }

  resources :papers, only: [:show, :edit, :update] do
    resources :links, only: :destroy, shallow: true
  end

  resources :pins, only: [:create, :destroy]

  resources :lists, only: [:new, :create, :index] do
    resources :references, only: [:show, :create, :destroy]
    resource :vote, controller: 'lists/votes', only: [:create, :destroy]
    resources :members, only: :destroy, controller: 'lists/members'
  end

  get 'lists/form_contributors(/:list_id)' => 'lists#form_contributors', as: :list_form_contributors

  resources :references do
    resource :vote, controller: 'references/votes', only: [:create, :destroy]
  end

  resources :summaries do
    resource :vote, controller: 'summaries/votes', only: [:create, :destroy]
  end

  resources :comments, only: [:create, :edit, :update, :destroy] do
    resource :vote, controller: 'comments/votes', only: [:create, :destroy]
  end

  resources :notifications, only: [:index]
  get '/read_notifications' => 'notifications#read_notifications', as:'read_notifications'

  resources :activities, only: [:index]

  scope ':username' do
    resources :lists, path: '/', except: [:new, :create], as: :user_lists, controller: 'users/lists' do
      resources :summaries, except: [:index, :show], controller: 'users/lists/summaries'
    end
    get ':user_list_id/:id' => 'references#show', as: :user_list_reference
  end

end

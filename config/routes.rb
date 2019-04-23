Rails.application.routes.draw do

  root 'activities#index'
  get '/about' => 'static_pages#about'
  get '/how-to' => 'static_pages#how_to'
  get '/manifest.json' => 'static_pages#manifest'
  get '/browserconfig.xml' => 'static_pages#browserconfig'
  get '/.well-known/acme-challenge/:id' => 'static_pages#lets_encrypt'

  devise_for :users, :controllers => {
    :registrations => 'auth/registrations',
    :omniauth_callbacks => 'auth/omniauth_callbacks'
  }

  devise_scope :user do
    get '/users/remove-attachment/:type' => 'auth/registrations#remove_attachment', :as => :users_remove_attachment
  end

  resource :charges, only: [:new, :create] do
    get :subscriptions
    post :subscribe
    get :unsubscribe
    post :webhook
  end

  resources :papers, only: [:show, :edit, :update] do
    resources :links, only: :destroy, shallow: true
  end

  resources :pins, only: [:create, :destroy]

  resources :lists, only: [:new, :create, :index] do
    resources :references, only: [:show, :create, :destroy]
    resource :vote, controller: 'lists/votes', only: [:create, :destroy]
    resources :members, only: :destroy, controller: 'lists/members'
  end

  post 'posts/load-open-graph' => 'posts#load_open_graph'
  resources :posts, only: [:create, :update, :destroy]

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

  resource :bookmarks, only: [:show, :create, :destroy]

  scope ':username' do
    resources :lists, path: '/', except: [:new, :create], as: :user_lists, controller: 'users/lists' do
      get 'remove-attachment/:type' => 'users/lists#remove_attachment', :as => :remove_attachment
      resources :summaries, except: [:index, :show], controller: 'users/lists/summaries'
    end
    get ':user_list_id/:id' => 'references#show', as: :user_list_reference
  end
end

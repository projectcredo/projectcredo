Rails.application.routes.draw do
  root 'lists#index'
  get '/about' => 'static_pages#about'
  get '/how-to' => 'static_pages#how_to'
  get '/.well-known/acme-challenge/:id' => 'static_pages#lets_encrypt'

  devise_for :users

  resources :papers, only: [:show, :edit, :update] do
    resources :links, only: :destroy, shallow: true
  end

  resources :lists, only: [:new, :create] do
    resource :vote, controller: 'lists/votes', only: [:create, :destroy]
    resource :pin, controller: 'lists/pins', only: [:create, :destroy]
    resources :members, only: :destroy, controller: 'lists/members'
    resources :references, only: [:show, :create, :destroy]
  end

  resources :references do
    resource :vote, controller: 'references/votes', only: [:create, :destroy]
  end

  resources :comments, only: [:create, :edit, :update, :destroy] do
    resource :vote, controller: 'comments/votes', only: [:create, :destroy]
  end

  scope ':username' do
    resources :lists, path: '/', except: [:new, :create], as: :user_lists, controller: 'users/lists'
    get ':user_list_id/:id' => 'references#show', as: :user_list_reference
  end

end

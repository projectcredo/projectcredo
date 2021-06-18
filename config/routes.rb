Rails.application.routes.draw do

  # /api routes
  namespace :api do
    get '/auth/me' => 'auth#me'
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      sessions: 'overrides/sessions',
      registrations: 'overrides/registrations',
      passwords: 'overrides/passwords',
      omniauth_callbacks: 'overrides/omniauth_callbacks',
    }
    delete '/auth/remove-attachment/:type' => 'registrations#remove_attachment'

    get '/profile/:username' => 'profile#index'

    resources :activities, only: [:index]

    resource :lists, only: [:show, :create, :update, :destroy]
    delete '/lists/remove-attachment/:type' => 'lists#remove_attachment'

    resources :posts, only: [:create, :update, :destroy]
    post '/posts/load-open-graph' => 'posts#load_open_graph'

    resources :summaries, only: [:create, :update, :destroy] 
    resources :pins, only: [:create, :destroy]
    resource :bookmarks, only: [:show, :create, :destroy]
    resources :comments, only: [:create, :edit, :update, :destroy]
    resource :votes, only: [:create, :destroy]
    resources :notifications, only: [:index]
    get '/unread-notifications' => 'notifications#unread', as:'unread_notifications'
    post '/read-notifications' => 'notifications#read_notifications', as:'read_notifications'
  end

#   resource :charges, only: [:new, :create] do
#     get :subscriptions
#     post :subscribe
#     get :unsubscribe
#     post :webhook
#   end
#
#   resources :papers, only: [:show, :edit, :update] do
#     resources :links, only: :destroy, shallow: true
#   end
#
#   resources :pins, only: [:create, :destroy]
#
#   post 'posts/load-open-graph' => 'posts#load_open_graph'
#   resources :posts, only: [:create, :update, :destroy]
#
#   get 'lists/form_contributors(/:list_id)' => 'lists#form_contributors', as: :list_form_contributors
#
#   resources :summaries, only: [:create, :update, :destroy] do
#     resource :vote, controller: 'summaries/votes', only: [:create, :destroy]
#   end
#
#   resources :comments, only: [:create, :edit, :update, :destroy] do
#     resource :vote, controller: 'comments/votes', only: [:create, :destroy]
#   end
#
#   resources :notifications, only: [:index]
#   get '/read_notifications' => 'notifications#read_notifications', as:'read_notifications'
#
#   resources :activities, only: [:index]
#
#   resource :bookmarks, only: [:show, :create, :destroy]
#
#   scope ':username' do
#     resources :lists, path: '/', except: [:new, :create], as: :user_lists, controller: 'users/lists' do
#       get 'remove-attachment/:type' => 'users/lists#remove_attachment', :as => :remove_attachment
#     end
#     get ':user_list_id/:id' => 'references#show', as: :user_list_reference
#   end
end

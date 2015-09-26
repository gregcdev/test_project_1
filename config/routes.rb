Rails.application.routes.draw do

  root 'home#index'

  get 'home/profile' => 'home#profile'

  get 'auth/:provider/callback', to: "sessions#create"

  delete 'sign_out', to: "sessions#destroy", as: 'sign_out'

  resources :polls do
    resources :options do
      member do
        post 'vote'
      end
    end
  end

  namespace :api, defaults: { format: 'json' } do
    get 'sign_in/google_oauth2' => "api#google_oauth2"
    namespace :v1 do
      resources :polls
      post 'vote' => "votes#cast_vote"
      get 'users/:id' => "users#show"
      get 'users/:id/followers' => "users#get_followers"
      get 'users/:id/follows' => "users#get_follows"
      get 'users/:id/follow' => "follows#create"
      get 'users/:id/unfollow' => "follows#destroy"
      get 'users/:user_id/polls' => "polls#user_polls"
      get 'feed' => "polls#feed"
    end
  end

end

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
    get 'google_oauth2' => "api#google_oauth2"
    namespace :v1 do
      resources :polls
      post 'vote' => "vote#cast_vote"
    end
  end

end

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: :sessions, registrations: :registrations,
    confirmations: :confirmations, passwords: :passwords}
    root to: "home#search_page"
    devise_scope :user do
      get '/users/almost_there' => 'confirmations#almost_there'
      post 'users/password/update' => 'passwords#update'
      post '/users/email_exist' => 'registrations#email_exist'
      post '/users/username_exist' => 'registrations#username_exist'
      post '/users/password/forgot_password' => 'passwords#forgot_password'
      put '/users/password/change_password' => 'passwords#change_password'
      get '/users/two_factor_authenticate' => 'sessions#two_factor_authenticate'
      get '/users/verify_otp' => 'sessions#new'
      post '/users/verify_otp' => 'sessions#verify_otp'
      get '/users/login' => 'sessions#new'
      post '/users/login' => 'sessions#login'
    end
    resources :terms do
      collection do
        get :terms
        get :terms_policy
      end
    end
    resources :home do
      collection do
        get :search_page
      end
    end
    resources :settings, only: [:index]
    resources :profiles do
      collection do
        post :update_profile
        get :my_profile
      end
    end
    resources :accounts do
      collection do
        post :validate_username
        post :delete_account
        patch :change_username
      end
    end
    resources :two_factor_authentications do
      collection do
        get :fetch_qr
        post :enable_two_factor_authentication
        post :disable_two_factor_authentication
      end
    end
    resources :groups do
      collection do
        get :owned_groups
        get :edit
        post :delete_group
      end
    end
    resources :group_listing do
      collection do
        get :public_groups
        get :internal_groups
        get :your_groups
        get :group_list
      end
    end
    resources :members do
      collection do
        get :member_list
        post :delete_member
        get :user_list
        get :group_members
      end
    end
    resources :documents
    resources :preview_documents do
      collection do
        get :get_documents
      end
    end
    resources :user_selections, only: [:create] do
      collection do
        post :select_all
      end
    end
  end

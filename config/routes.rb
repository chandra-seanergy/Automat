Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: :sessions, registrations: :registrations,
    confirmations: :confirmations, passwords: :passwords}
  root to: "home#index"
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
 end

Rails.application.routes.draw do
  devise_for :admins

  authenticated do
    root :to => 'questions#index', as: :authenticated
  end

  root 'questions#new'

  resources :questions, except: %i(destroy)
  resources :admins
end

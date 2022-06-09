# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "kudos#index"
  
  devise_scope :admin_user do
    devise_for :admin_users, path: 'admin', controllers: { sessions: "admin_users/sessions" }
    match '/admin', to: 'admin_users/sessions#new', via: 'get'
  end

  devise_for :employees, path: 'employees', controllers: { sessions: "employees/sessions", registrations: "employees/registrations" }

  resources :kudos
  resources :rewards, only: [:index, :show] do
    collection do
      resources :orders, only: %i[index new create]
    end
  end
  
  namespace :admin_users, path: 'admin' do
    resources :kudos, only: [:index, :destroy]
    resources :employees, only: [:index, :edit, :update, :destroy]
    resources :company_values, except: [:show]
    resources :rewards
    resources :pages, only: [] do
      collection do
        get :dashboard
      end
    end
  end
end

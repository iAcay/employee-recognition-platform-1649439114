# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "kudos#index"
  
  devise_scope :admin_user do
    devise_for :admin_users, path: 'admin', controllers: { sessions: "admin_users/sessions" }
    match '/admin', to: 'admin_users/sessions#new', via: 'get'
  end

  devise_for :employees, path: 'employees', controllers: { sessions: "employees/sessions", registrations: "employees/registrations" }

  resources :kudos
  
  namespace :admin_users, path: 'admin' do
    resources :kudos, only: [:index, :destroy]
    resources :pages, only: [] do
      collection do
        get :dashboard
      end
    end
    resources :employees, only: [:index, :edit, :update, :destroy]
  end
end

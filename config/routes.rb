# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "kudos#index"
  
  devise_scope :admin_user do
    devise_for :admin_users, path: 'admin', controllers: { sessions: "admin_users/sessions" }
    match '/admin', to: 'admin_users/sessions#new', via: 'get'
  end

  devise_for :employees, path: 'employees', controllers: { sessions: "employees/sessions", registrations: "employees/registrations" }

  resources :kudos
  resources :rewards, only: %i[index show] do
    collection do
      resources :orders, only: %i[new create]
      resources :display_orders, only: %i[index]
    end
  end
  
  namespace :admin_users, path: 'admin' do
    resources :kudos, only: %i[index destroy]
    resources :employees, only: %i[index edit update destroy] do
      collection do
        resources :orders, only: %i[index update] do
          collection do
            get 'export_to_csv'
          end
        end
        get 'edit_number_of_available_kudos_for_all'
        patch 'add_available_kudos_for_all'
      end
    end
    resources :company_values, except: %i[show]
    resources :rewards
    resources :categories, except: %i[show]
    resources :pages, only: [] do
      collection do
        get :dashboard
      end
    end
  end
end

# frozen_string_literal: true

Rails.application.routes.draw do
  resources :kudos
  
  devise_for :employees
  
  root to: "kudos#index"
end

Rails.application.routes.draw do
  devise_for :users

  root 'appointments#index'
  resources :appointments, only: %w(index new create edit update) do
    collection do
      get :past
    end
  end

  namespace :api do
    resources :appointments, only: %w(index create) do
      collection do
        get :by_date
      end
    end
  end

  resources :user_statistics, only: :index
end

Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :registration, only: [:new, :create]

  root "dashboards#show"
  resource :dashboard, only: :show

  namespace :routine do
    resources :task_templates, except: :show
    resources :daily_tasks, only: [:create, :edit, :update, :destroy] do
      patch :complete, on: :member
      patch :reopen, on: :member
      patch :skip, on: :member
    end
  end

  resource :settings, only: [:show, :edit, :update]

  # Test-only deterministic sign-in for system tests (never mounted in prod).
  if Rails.env.test?
    get "test_sign_in/:user_id", to: "test_sessions#create", as: :test_sign_in
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end

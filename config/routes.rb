Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :registration, only: [:new, :create]

  root "dashboards#show"
  # Day view: the dashboard renders any date. Today is the default (root).
  get "days/:date", to: "dashboards#show", as: :day, constraints: { date: /\d{4}-\d{2}-\d{2}/ }
  # Full month calendar; click a day to open its view.
  get "calendar(/:month)", to: "calendars#show", as: :calendar, constraints: { month: /\d{4}-\d{2}/ }

  namespace :routine do
    resources :task_templates, except: :show
    resources :daily_tasks, only: [:create, :edit, :update, :destroy] do
      patch :complete, on: :member
      patch :reopen, on: :member
      patch :skip, on: :member
    end
  end

  namespace :shopping do
    resources :stores, except: :show
    resources :shopping_items, except: :show
    resources :shopping_lists do
      resources :shopping_list_items, only: [:create]
    end
    resources :shopping_list_items, only: [:edit, :update, :destroy] do
      patch :buy, on: :member
      patch :unbuy, on: :member
    end
  end

  namespace :food do
    get "plan", to: "plans#show", as: :plan
    post "plan/generate_shopping_list", to: "plans#generate_shopping_list", as: :plan_generate_shopping_list

    resources :meals do
      resources :meal_ingredients, only: [:create]
    end
    resources :meal_ingredients, only: [:edit, :update, :destroy]
    resources :planned_meals, only: [:create, :edit, :update, :destroy]
  end

  resource :settings, only: [:show, :edit, :update]

  # Test-only deterministic sign-in for system tests (never mounted in prod).
  if Rails.env.test?
    get "test_sign_in/:user_id", to: "test_sessions#create", as: :test_sign_in
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end

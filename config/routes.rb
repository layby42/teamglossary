Rails.application.routes.draw do

  get 'login' => 'user_sessions#new'
  match 'login' => 'user_sessions#create', :via => [:post, :patch]
  match 'logout' => 'user_sessions#destroy', :via => [:get, :delete]

  resources :password_resets, :only => [:new, :create, :edit, :update]

  namespace :admin do |admin|
    resources :settings, :only => [:index]
    resources :languages, only: [:index, :new, :create, :edit, :update, :show] do
      get :changes, on: :member
      resources :teams, only: [:new, :create, :edit, :update, :destroy]
    end

    resources :users, only: [:index, :new, :create, :edit, :update, :show] do
      put :welcome, on: :member
      get :changes, on: :member
      resources :teams, only: [:new, :create, :destroy]
    end

    resources :proper_name_types, only: [:index, :new, :create, :edit, :update] do
      get :changes, on: :member
    end

    resources :reference_types, only: [:index, :new, :create, :edit, :update] do
      get :changes, on: :member
    end

    resources :sanskrit_statuses, only: [:index, :new, :create, :edit, :update] do
      get :changes, on: :member
    end

    resources :integration_statuses, only: [:index, :new, :create, :edit, :update] do
      get :changes, on: :member
    end

    resources :general_statuses, only: [:index, :new, :create, :edit, :update] do
      get :changes, on: :member
    end
  end

  resources :languages, only: [:show] do
    resources :glossary_names, only: [:new, :create, :show, :edit, :update] do
      get :changes, on: :member
    end

    resources :glossary_titles, only: [:new, :create, :show, :edit, :update] do
      get :changes, on: :member
    end

    resources :glossary_terms, only: [:new, :create, :show, :edit, :update] do
      get :changes, on: :member

      resources :glossary_term_translations, only: [:new, :create, :show, :edit, :update] do
        get :changes, on: :member
      end
    end
  end

  root :to => 'home#index'
end

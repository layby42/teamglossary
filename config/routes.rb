Rails.application.routes.draw do

  get 'login' => 'user_sessions#new'
  match 'login' => 'user_sessions#create', :via => [:post, :patch]
  match 'logout' => 'user_sessions#destroy', :via => [:get, :delete]
  match 'download' => 'home#download', :via => [:get]
  get 'help' => 'help/articles#index', :via => [:get]

  resources :password_resets, :only => [:new, :create, :edit, :update]

  namespace :help do |admin|
    resources :articles
  end

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

    resources :tasks, only: [:index, :new, :create, :edit, :update] do
      get :changes, on: :member
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

    resources :imports, only: [:index, :new, :create] do
      post :general_menu, on: :collection
      post :hopkins, on: :collection
    end

    resources :help_categories, only: [:index, :new, :create, :edit, :update] do
      get :changes, on: :member
    end

    resources :diagnostics, only: [:index]
  end

  resources :languages, only: [:show] do

    resources :glossary_terms, only: [:new, :create, :show, :edit, :update, :destroy] do
      get :changes, on: :member
      put :approve, on: :member

      get :reject, on: :member
      post :reject, on: :member

      put :propose, on: :member

      resources :glossary_term_translations, only: [:create, :edit, :update, :destroy] do
        get :changes, on: :member
      end
    end

    resources :glossary_names, only: [:new, :create, :show, :edit, :update, :destroy] do
      get :changes, on: :member
      put :approve, on: :member

      get :reject, on: :member
      post :reject, on: :member

      put :propose, on: :member

      resources :glossary_name_translations, only: [:create, :edit, :update, :destroy] do
        get :changes, on: :member
      end
    end

    resources :glossary_titles, only: [:new, :create, :show, :edit, :update, :destroy] do
      get :changes, on: :member
      put :approve, on: :member

      get :reject, on: :member
      post :reject, on: :member

      put :propose, on: :member

      resources :glossary_title_translations, only: [:create, :edit, :update, :destroy] do
        get :changes, on: :member
      end
    end

    resources :general_menus, only: [:show, :destroy] do
      get :changes, on: :member

      get :open, on: :member

      resources :general_menu_translations, only: [:create, :edit, :update, :destroy] do
        get :changes, on: :member
      end

      resources :general_menu_actions, only: [:new, :create, :edit, :update, :destroy] do
        get :changes, on: :member
      end
    end

    resources :comments, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :comments, only: [:index]

  resources :works, only: [:index] do
    get :email, on: :collection
  end

  resources :invoices, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    put :email, on: :member
    get :changes, on: :member
  end

  root :to => 'home#index'
end

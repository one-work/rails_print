# frozen_string_literal: true
Rails.application.routes.draw do
  namespace :print, defaults: { business: 'print' } do
    controller :home do
      post :message
      post :ready
      post :exception
      post :complete
      post :subscribe
      post :unsubscribe
      post :authorized
      post :offline
    end
    resources :devices do
      collection do
        get :test
        post :err
      end
    end

    namespace :api, defaults: { namespace: 'api' } do
      resources :printers, only: [] do
        resources :tasks, only: [:create] do
          collection do
            post :template
          end
        end
      end
    end

    namespace :panel, defaults: { namespace: 'panel' } do
      root 'home#index'
      resources :mqtt_apps
      resources :mqtt_users do
        collection do
          get :ip
        end
        resources :mqtt_acls
      end
      resources :mqtt_printers do
        collection do
          post :search_organs
        end
        member do
          post :organ
        end
        resources :tasks do
          collection do
            delete :clear
          end
          member do
            post :resend
          end
        end
      end
      resources :templates do
        resources :template_items do
          member do
            patch :reorder
          end
        end
      end
    end

    namespace :admin, defaults: { namespace: 'admin' } do
      root 'home#index'
      controller :home do
        get :bind
        post :scan
        post :replace
        post :inner
      end
      resources :templates do
        resources :template_tasks
        resources :template_items do
          member do
            patch :reorder
          end
        end
      end
      resources :printers, only: [] do
        resources :tasks
      end
      resources :mqtt_printers do
        collection do
          get 'bind/:dev_imei' => :bind
          post :scan
        end
        member do
          post :test_print
        end
        resources :templates, controller: 'printer/templates' do
          resources :template_tasks, controller: 'printer/template_tasks'
        end
      end
      resources :bluetooth_printers
    end
  end
end

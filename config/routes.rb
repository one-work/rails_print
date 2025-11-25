# frozen_string_literal: true
Rails.application.routes.draw do
  namespace :print, defaults: { business: 'print' } do
    controller :home do
      post :message
      post :ready
      post :exception
      post :complete
    end

    namespace :panel, defaults: { namespace: 'panel' } do
      root 'home#index'
      resources :mqtt_apps
      resources :mqtt_users do
        resources :mqtt_acls
      end
      resources :mqtt_printers do
        collection do
          post :search_organs
        end
        member do
          post :organ
        end
      end
      resources :jia_bo_apps do
        resources :jia_bo_printers do
          collection do
            post :sync
          end
          member do
            patch :test
          end
        end
      end
    end

    namespace :admin, defaults: { namespace: 'admin' } do
      root 'home#index'
      resources :devices
      resources :jia_bo_printers do
        collection do
          post :scan
        end
      end
      resources :mqtt_printers, except: [:destroy]
    end
  end
end

Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get "dashboard", to: "pages#dashboard"

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "dashboard", to: "pages#dashboard"
  post "create_order", to: "pages#create_order", as: :create_order
end

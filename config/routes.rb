require 'sidekiq/web'

Rails.application.routes.draw do
  defaults format: :json do
    devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', registration: 'signup' }
    
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
    get "up" => "rails/health#show", as: :rails_health_check
    get "home" => 'home#index'
    get "invoices" => 'invoices#index'
    get '/invoices/report' => 'invoices#report' 
    
    # Montar a interface web do Sidekiq
    mount Sidekiq::Web => '/sidekiq'
    post 'upload_xml', to: 'xmls#upload'
    # Define the root path route ("/")
    # root "posts#index"
  end
end

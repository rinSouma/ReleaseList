Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'login', to: 'login#index'
  post 'login', to: 'login#create'
  
  root 'home#index'

  #API用
  namespace :api, {format: 'json'} do
    namespace :v1 do
      namespace :insert do
        post "/" , :action => "index"
      end
    end
  end
end

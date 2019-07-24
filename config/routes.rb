Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'login', to: 'login#index'
  post 'login', to: 'login#create'
  get 'logout', to: 'logout#index'
  get 'home/input', to: 'home#input'
  post 'home/input', to: 'home#get_item'
  post 'entry', to: 'entry#trello_entry'
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

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #API用
  namespace :api, {format: 'json'} do
    namespace :v1 do
      namespace :insert do
        get "/" , :action => "index"
      end
    end
  end
end

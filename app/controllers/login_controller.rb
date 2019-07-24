class LoginController < ApplicationController
    protect_from_forgery :except => [:create]
    def index
        trello_api_url = "https://trello.com/1/authorize?expiration=never&name=ReleaseList&scope=read,write" + \
                            "&response_type=token&return_url=https://" + request.raw_host_with_port + "/trellu_list/login_callback.html" + \
                            "&key=" + ENV['TRELLO_API_KEY']
        puts trello_api_url    
        redirect_to(trello_api_url)
    end
   
    def create
        _, token = params[:token].split("=")
        session[:token] = token
        redirect_to root_path
    end
end

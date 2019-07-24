class LogoutController < ApplicationController
    def index
        session[:token] = nil
        redirect_to root_path
    end
end

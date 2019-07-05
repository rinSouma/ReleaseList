class HomeController < ApplicationController
    include Trello
    def index
        @data = get_boards(session[:token])
    end
end

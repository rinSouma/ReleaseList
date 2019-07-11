class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Trello

  def getUser
    if session[:token].blank?
      return
    end
    trello = Trello_API.new(session[:token], ENV['TRELLO_API_KEY'])
    user_data = trello.get_user
    if user_data.present? then
      @user = {user_name:user_data["fullName"].to_s, avatar:user_data["avatarUrl"].to_s+"/170.png"}
    end
  end
end

class LoginController < ApplicationController

  def index
  end


  def create
    user_details = "#{ params[:channel] }_#{ params[:title] }"

    if cookies[:user_details] = { value: user_details, expires: 1.day.from_now.utc }
      redirect_to root_path

    else
      cookies.delete :user_details

      redirect_to login_index_path
    end
  end

end

class MainController < ApplicationController
  before_filter :check_user_details

  def index
  end


  def logout
    cookies.delete :user_details

    redirect_to login_index_path
  end

  private

  def check_user_details
    if cookies[:user_details].nil?
      redirect_to login_index_path
    end
  end

end

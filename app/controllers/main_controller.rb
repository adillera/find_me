class MainController < ApplicationController
  before_filter :check_user_details

  def index
  end

  private

  def check_user_details
      redirect_to login_index_path
  end

end

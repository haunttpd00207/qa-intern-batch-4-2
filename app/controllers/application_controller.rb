class ApplicationController < ActionController::Base
  add_flash_types :success, :danger, :warning, :info
  include SessionsHelper

  private

  def logged_in_user
    return if logged_in?
    store_location
    redirect_to root_path, danger: "Please log in."
  end
end

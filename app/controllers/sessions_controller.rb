class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      log_in @user
      if params[:session][:remember_me] == "1"
        remember @user
      else
        forget @user
      end
      	redirect_to @user
    else
      respond_to do |format|
        format.js { flash.now[:danger] = "Invalid email/password combination" }
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end

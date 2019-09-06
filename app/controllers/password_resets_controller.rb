class PasswordResetsController < ApplicationController
  before_action :load_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_path, info: "Email sent with password reset instructions"
    else
      respond_to do |format|
        format.js { flash.now[:danger] = "Email address not found" }
      end
    end
  end

  def edit; end

  def update
    if @user.update user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      redirect_to @user, success: "Password has been reset."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user
    redirect_to new_password_reset_path, danger: "Error. Email not found"
  end

  def valid_user
    return if @user&.authenticated?(:reset, params[:token])
    redirect_to root_path
  end

  def check_expiration
    if @user.password_reset_expired?
      redirect_to new_password_reset_path, danger: "Password reset has expired."
    end
  end
end

class UsersController < ApplicationController
  before_action :load_user, only: :show

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      redirect_to @user, success: "Sign up successfully!"
    else
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :phone, :address, :picture,
                                 :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    redirect_to root_path, danger: "User not found"
  end
end

class ProfileController < ApplicationController

  before_filter :require_login

  def edit
    @user = current_user
    redirect_to root_path unless @user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_with_password(params[:user])
      sign_in @user, :bypass => true
      redirect_to root_path, :notice => 'Reset Password successfully'
    else
      render 'edit'
    end
  end
end

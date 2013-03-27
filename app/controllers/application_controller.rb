class ApplicationController < ActionController::Base
  protect_from_forgery

  REQUIRE_LOGIN = 'You must be logged in to access this section'
  REQUIRE_ADMIN = 'You must be admin to access this section'
  NO_PERMISSION = 'You do not have permission to access this section'

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :notice => NO_PERMISSION
  end

  private

  def require_login
    unless user_signed_in?
      redirect_to new_user_session_path, :notice => REQUIRE_LOGIN
    end
  end

  def require_admin
    unless current_user and current_user.admin?
      redirect_to root_path, :notice => REQUIRE_ADMIN
    end
  end
end

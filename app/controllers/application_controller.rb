class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'You do not have permission to access this section'
    redirect_to root_path
  end

  private

  def require_login
    unless logged_in?
      flash[:error] = 'You must be logged in to access this section'
      redirect_to new_user_session_path
    end
  end

  def logged_in?
    !!current_user
  end

end

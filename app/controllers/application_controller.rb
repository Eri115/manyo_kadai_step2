class ApplicationController < ActionController::Base
  include SessionsHelper
  helper_method :current_user
  before_action :login_required
  

  private

  def login_required
    unless current_user 
      flash[:notice] = 'ログインしてください'
      redirect_to new_session_path 
    end
  end

  def logged_in_redirect
    if current_user
      flash[:notice] = 'ログアウトしてください'
      redirect_to tasks_path
    end
  end

  def require_admin
    unless current_user&.admin?
      flash[:alert] = '管理者以外アクセスできません'
      redirect_to tasks_path
    end
  end
end



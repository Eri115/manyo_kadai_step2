class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new
    redirect_to tasks_path if logged_in?
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = 'ログインしました'
      redirect_to tasks_path
    else
      flash.now[:notice] = 'メールアドレスまたはパスワードに誤りがあります'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end
end

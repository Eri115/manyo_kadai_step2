class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    #binding.irb
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = 'ログインしました'
      redirect_to tasks_path
    else
      flash.now[:notice] = 'メールアドレスまたはパスワードに誤りがあります'
      render :new
      #binding.irb
    end
  end


  def destroy
      session.delete(:user_id)
      flash[:notice] = 'ログアウトしました'
      redirect_to new_session_path     
  end
end

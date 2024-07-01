class UsersController < ApplicationController
  before_action :correct_user, only: [:show,:update,:destroy,:edit]
  skip_before_action :login_required, only: [:new, :create]
  before_action :redirect_if_logged_in, only: [:new]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  #ユーザーが新しいアカウントを作成する際に使われるやつ
  def create
    @user = User.new(user_params)
    #パラメータでフィルタリングされたやつ使用して、許可されたやつのみ抽出

    if @user.save 
      session[:user_id] = @user.id
      #保存が成功したら、そのユーザーのIDをsessionに保存される仕組み。
      #この時、ログイン状態になる
      redirect_to tasks_path 
      #ログインできたら、tasksに遷移されるようリダイレクトする
      flash[:notice] = 'アカウントを登録しました'
       #保存できたら、タスク一覧画面表示する。
    else
      render :new #もし、保存できなかったらnewページに遷移させる。
    end
  end

  def edit
  end

  def show
  end

  def update
    @user = User.find(params[:id])

    if user_params[:password].blank?
      params_to_update = user_params.except(:password, :password_confirmation)
    else
      params_to_update = user_params.permit(:name, :email, :password, :password_confirmation)
    end
  
    if @user.update(params_to_update)
      redirect_to user_path(@user), notice: 'アカウントを更新しました'
    else
      render :edit
    end
  end

  def destroy
    #binding.irb
    @user.destroy
    flash[:notice] = 'タスクを削除しました'
    redirect_to new_session_path
  end


  private

  def user_params
    params.require(:user).permit( :name, :email, :password, :password_confirmation)
  end

  def correct_user
    #binding.irb
    @user = User.find(params[:id])
    redirect_to current_user unless current_user?(@user)
  end
end

def redirect_if_logged_in
  if logged_in?
    redirect_to tasks_path, alert: 'ログアウトしてください'
  end
end

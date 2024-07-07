class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path,notice: t('users.create.created')
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks
  end

  def update
    if user_params[:admin] == 'false' && @user.admin? && User.where(admin: true).count == 1
      flash[:alert] = t('errors.messages.last_admin')
      redirect_to edit_admin_user_path(@user)
    elsif @user.update(user_params)
      redirect_to admin_users_path, notice: 'ユーザを更新しました'
    else
      flash.now[:alert] = 'ユーザの更新に失敗しました'
      render :edit
    end
  end

  def destroy
    if @user.admin?
      flash[:alert] = "管理者が0人になるため削除できません"
    else
      begin
        @user.destroy
        flash[:notice] = 'ユーザを削除しました'
      rescue StandardError => e
        flash[:alert] = e.message
      end
    end
  
    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end


  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation,:admin)
  end


  def require_admin
    redirect_to tasks_path unless current_user.admin?
    flash[:alert] = '管理者以外アクセスできません'
  end
end



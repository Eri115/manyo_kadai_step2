class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]
  

  
     #created_at 列（タスクが作成された日時を表す列）を基準に降順（DESC）で並べ替えるメソッド
    def index
      @tasks = current_user.tasks.order(created_at: :desc)
      @search_params = search_params
      #binding.irb
      @tasks = Task.search(@search_params).merge(@tasks) if @search_params.present?
  
      if params[:sort] == 'deadline_on'
        @tasks = @tasks.order(deadline_on: :asc)
      elsif params[:sort_priority] == 'true'
        @tasks = @tasks.order(priority: :desc, created_at: :desc)
      else
        @tasks = @tasks.order(created_at: :desc)
      end
      @tasks = @tasks.page(params[:page]).per(10)
    end

  
  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    #@task.user_id = current_user.id
    #binding.irb
    if @task.save
      flash[:notice] = 'タスクを登録しました'
      redirect_to tasks_path#, notice: t('.created')
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:notice] = 'タスクを更新しました'
      redirect_to task_path(@task)#,notice: t('.updated')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:alert] = 'タスクを削除しました'
    redirect_to tasks_path#, notice: t('.destroyed')
  end


  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, label_ids: [])
  end
  
  def search_params
    params.fetch(:search, {}).permit(:title, :status, :label )
  end

  def authorize_user
    unless current_user == @task.user
      flash[:alert] = 'アクセス権限がありません'
      redirect_to tasks_path
    end
  end
end

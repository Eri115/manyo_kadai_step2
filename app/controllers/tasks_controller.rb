class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]


  
     #created_at 列（タスクが作成された日時を表す列）を基準に降順（DESC）で並べ替えるメソッド
     def index
      @tasks = current_user.tasks.order(created_at: :desc)
      @search_params = search_params
  
      if params[:sort] == 'deadline_on'
        @tasks = @tasks.order(deadline_on: :asc)
      elsif params[:sort_priority] == 'true'
        @tasks = @tasks.order(priority: :desc, created_at: :desc)
      else
        @tasks = @tasks.order(created_at: :desc)
      end
  
      @tasks = Task.search(@search_params).merge(@tasks) if @search_params.present?
  
      @tasks = @tasks.page(params[:page]).per(10)
    end

  
  def new
    @task = Task.new
  end

  def create
    #binding.irb
    @task = current_user.tasks.new(task_params)
    @task.user_id = current_user.id
    #binding.irb
    if @task.save
      redirect_to tasks_path, notice: t('.created')
    else
      render :new
    end
  end

  def show
    #current_user.tasks.find(params[:id])
  end

  def edit
    #current_user.tasks.find(params[:id])
  end

  def update
    if @task.update(task_params)
      #flash[:notice] = 'Task was successfully updated.'
      redirect_to task_path(@task),notice: t('.updated')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    #flash[:notice] = 'Task was successfully destroyed.'
    redirect_to tasks_path, notice: t('.destroyed')
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end


  def task_params
     params.require(:task).permit(:title, :content,:deadline_on, :priority, :status)
    #binding.irb
    #Parameters {"title"=>"", "content"=>"", "deadline_on"=>"2024-06-24", "priority"=>"0", "status"=>"0"} permitted: true>
  end
  
  def search_params
    params.fetch(:search, {}).permit(:title, :status,)
  end
end


def authorize_user
  unless current_user == @task.user
    flash[:alert] = 'アクセス権限がありません'
    redirect_to tasks_path
  end
end

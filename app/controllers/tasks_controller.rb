class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

   
    #created_at 列（タスクが作成された日時を表す列）を基準に降順（DESC）で並べ替えるメソッド
    def index
      @tasks = Task.all
  
      # Sort by created_at by default
      @tasks = @tasks.order(created_at: :desc)
  
      # Sort by deadline_on if requested
      if params[:sort_deadline_on].present?
        @tasks = @tasks.order(deadline_on: :asc)
      end
  
      # Sort by priority if requested
      if params[:sort_priority].present?
        @tasks = @tasks.order(priority: :desc)
      end
  
      # Apply search filters
      if params[:search].present?
        search_params = params[:search].permit(:title, :status, :priority)
        if search_params[:title].present?
          @tasks = @tasks.where('title LIKE ?', "%#{search_params[:title]}%")
        end
        if search_params[:status].present?
          @tasks = @tasks.where(status: search_params[:status])
        end
        if search_params[:priority].present?
          @tasks = @tasks.where(priority: search_params[:priority])
        end
      end
  
      @tasks = @tasks.page(params[:page]).per(10)
    end
  
  def new
    @task = Task.new
  end

  def create
    #binding.irb
    @task = Task.new(task_params) 

    if @task.save
      redirect_to tasks_path, notice: t('.created')
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
     params.require(:task).permit(:title, :content, :deadline_on, :priority, :status,:sort_deadline_on)
    #binding.irb
    #Parameters {"title"=>"", "content"=>"", "deadline_on"=>"2024-06-24", "priority"=>"0", "status"=>"0"} permitted: true>
  end
  
  def search_params
    params.fetch(:search, {}).permit(:title, :status)
  end
end
class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

   
    #created_at 列（タスクが作成された日時を表す列）を基準に降順（DESC）で並べ替えるメソッド
  def index
    @tasks = Task.order(created_at: :desc)
                 .page(params[:page])
                 .per(10)

    if params[:sort_deadline_on] #saveメソッドは単一のレコードのみ使える。ここでは複数レコードがあるから使えない
       @tasks = Task.order(deadline_on: :asc) #params[:sort_deadline_on]に値があれば、終了期限でソートした値を返し
                    .page(params[:page])
                    .per(10)
    end

    if @tasks = Task.all.order(deadline_on: :asc) #params[:sort_deadline_on]に値がなければ、Tasks.allなどで取り出した値を返す。）
                        .page(params[:page])
                        .per(10)                  
    end

    if params[:search].present?
      if #パラメータにタイトルとステータスの両方があった場合
      elsif #パラメータにタイトルのみがあった場合
      elsif #パラメータにステータスのみがあった場合
      end
    end

      
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
end
  
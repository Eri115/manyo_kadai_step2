class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

   
    #created_at 列（タスクが作成された日時を表す列）を基準に降順（DESC）で並べ替えるメソッド
    def index
      @tasks = Task.all
  
      # デフォルトで作成日時で降順にソート
      @tasks = @tasks.order(created_at: :desc) 

      if params[:sort_deadline_on].present?# 終了期限でソートする場合
         @tasks = Task.all.order(deadline_on: :asc) #＠tasksだとcreated_atとdeadline_on両方の値が考慮されている
      end
  
      if params[:sort_priority].present? # 優先度でソートする場合
         @tasks = Task.all.order(priority: :desc, created_at: :desc)
       
      end
  
      if params[:search].present? # 検索フィルターを適用する場合
         search_params = params[:search].permit(:title, :status, :priority)
      
        if search_params[:title].present? #タイトルによる部分一致検索を行う
            @tasks = @tasks.where('title LIKE ?', "%#{search_params[:title]}%")
        end

        if search_params[:status].present?  #ステータスによる完全一致検索を行う
            @tasks = @tasks.where(status: search_params[:status])
        end
        
        if search_params[:priority].present? #優先度による完全一致検索を行う
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
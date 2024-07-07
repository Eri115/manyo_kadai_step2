class LabelsController < ApplicationController
  def index
    @labels = Label.all
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.create(label_params)
    #@label = Label.new(label_params)
    if @label.save
      flash[:notice] = 'ラベルを登録しました'
      redirect_to labels_path
    else
      render :new
    end
  end

  def edit
    @label = Label.find(params[:id])
  end

  def update
    #@label = current_user.labels.build(label_params)
    @label = Label.find(params[:id])
    if @label.update(label_params)
      flash[:notice] = 'ラベルを更新しました'
      redirect_to labels_path
    else
      render :edit
    end
  end

  def destroy
    @label = Label.find(params[:id])

    if @label.destroy
      flash[:alert]= 'ラベルを削除しました'
      redirect_to labels_path
    else
      #flash[:alert] = '削除に失敗しました'
      redirect_to labels_path
    end
  end

  private

  def label_params
    params.require(:label).permit(:name, :user_id)
  end
end

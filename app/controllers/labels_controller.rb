class LabelsController < ApplicationController
  def index
    @labels = Label.all
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.build(label_params)
    #@label = Label.new(label_params)
    if @label.save
      redirect_to labels_path, notice:'ラベルを登録しました'
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
      redirect_to label_path(@label), notice: 'ラベルを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @label = Label.find(params[:id])

    if @label.destroy
      redirect_to labels_path, notice: 'ラベルを削除しました'
    else
      #flash[:alert] = '削除に失敗しました'
      redirect_to labels_path
    end
  end

  private

  def label_params
    params.require(:label).permit(:name )
  end
end

class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true
 
  enum priority: { low: 0, medium: 1, high: 2 }
  enum status: { waiting: 0, working: 1, completed: 2 }


  scope :deadline_asc_sort, -> { order(deadline_on: :asc) }
  # 締め切り日（deadline_on）を昇順（古い順）でソートするスコープ
  scope :priority_high_sort, -> { order(priority: :desc) }
  #priority_high_sort: 優先度（priority）を降順（高い順）でソートするスコープです。
  scope :created_at_newest_first, -> { order(created_at: :desc) }
  #created_at_newest_first: 作成日時（created_at）を降順（新しい順）でソートするスコープです。



  scope :search, -> (search_params) do
    return all if search_params.blank?
    #search: 指定された検索パラメータに基づいてタイトル（title）とステータス（status）でフィルタリングするスコープ。
    #search_paramsが空であれば、全てのタスクを返す。
    where(title: search_params[:title], status: search_params[:status])
  end
end

